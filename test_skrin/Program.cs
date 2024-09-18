using System;
using System.Data.SqlClient;
using System.Xml.Linq;
using Npgsql;
using test_skrin;

internal class Program
{
    static void Main(string[] args)
    {
        //подключаемся к бд
        
        Console.WriteLine("При помощи этой программы Вы можете загрузить данные о покупках из XML файла в базу данных." +
            "Введите 1, чтобы указать файл и начать загрузку и любой другой знак для выхода из программы.");
        string answer = Console.ReadLine();

        while (answer.Equals("1"))
        {
            NpgsqlConnection nc = ConnectToDB.connect();
            Console.WriteLine("Введите путь к файлу на вашем компьютере\n");
            string pathToFile = "";
            int usersCount = 0;
            int purchasesCount = 0;
            int ordersCount = 0;
            int productsCount = 0;
            int addrCount = 0;
            int phonesCount = 0;
            pathToFile = Console.ReadLine();
            XDocument xmlDoc = new XDocument();
            try
            {
                try
                {
                    // Загружаем XML файл
                    xmlDoc = XDocument.Load(pathToFile);
                    Console.WriteLine("Файл успешно открыт");
                }
                catch(Exception ex)
                {
                    Console.WriteLine($"Ошибка при загрузке {pathToFile}");
                    return;
                }

                // Подключаемся к базе данных
                using (nc)
                {
                    foreach (var test in xmlDoc.Descendants("test"))
                    {
                        foreach (var user in test.Descendants("user"))
                        {
                            string email = user.Element("email").Value;
                            if (String.IsNullOrWhiteSpace(email))
                            {
                                throw new Exception("Введите адрес электронной почты");
                            }
                            int userId = 0;
                            using (var command = new NpgsqlCommand("select user_id from users where email=@email", nc))
                            {
                                command.Parameters.AddWithValue("email", email);
                                using (var reader = command.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        userId = reader.GetInt32(0);
                                    }
                                }
                            }
                            if (userId == 0)
                            {

                                string fio = user.Element("fio").Value;
                                string password = user.Element("password").Value;
                                DateTime birthday = new DateTime();
                                try
                                {
                                    birthday = DateTime.Parse(user.Element("birthday").Value);
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine("Неверный формат даты рождения пользователя");
                                    return;
                                }
                                if (String.IsNullOrWhiteSpace(fio) || String.IsNullOrWhiteSpace(password))
                                {
                                    throw new Exception($"Введите ФИО и пароль для пользователя с эл. почтой {email}");
                                }
                                else
                                {
                                    using (var command = new NpgsqlCommand("INSERT INTO Users (fio, email, user_password, birthday) VALUES (@fio, @email, @up, @bd) returning user_id", nc))
                                    {
                                        command.Parameters.AddWithValue("@fio", fio);
                                        command.Parameters.AddWithValue("@email", email);
                                        command.Parameters.AddWithValue("@up", password);
                                        command.Parameters.AddWithValue("@bd", birthday);
                                        userId = Convert.ToInt32(command.ExecuteScalar());
                                    }
                                    usersCount++;
                                }
                            }

                            foreach (var purchase in user.Descendants("purchase"))
                            {
                                //это слой покупок
                                int purchaseId = 0;
                                if (String.IsNullOrWhiteSpace(purchase.Element("total_price").Value) || String.IsNullOrWhiteSpace(purchase.Element("purchase_date").Value))
                                {
                                    throw new Exception("Дата заказа и общая сумма - обязательные поля");
                                }
                                else
                                {
                                    DateTime purchaseDate = new DateTime();
                                    try
                                    {
                                        purchaseDate = DateTime.Parse(purchase.Element("purchase_date").Value);
                                    }
                                    catch (Exception ex)
                                    {
                                        Console.WriteLine("Неверный формат ввода даты заказа");
                                        return;
                                    }
                                    int totalPrice = int.Parse(purchase.Element("total_price").Value);
                                    using (var command = new NpgsqlCommand("INSERT INTO Purchases (user_id, order_date, total_price) VALUES (@ui, @od, @tp) returning purchase_id", nc))
                                    {
                                        command.Parameters.AddWithValue("@ui", userId);
                                        command.Parameters.AddWithValue("@od", purchaseDate);
                                        command.Parameters.AddWithValue("@tp", totalPrice);
                                        purchaseId = Convert.ToInt32(command.ExecuteScalar());
                                    }
                                    purchasesCount++;
                                }

                                //это слой состава заказов
                                foreach (var order in purchase.Descendants("ordercomposition"))
                                {
                                    int prodId = 0;
                                    int orderCompId = 0;
                                    if (String.IsNullOrWhiteSpace(order.Element("positions_count").Value) || String.IsNullOrWhiteSpace(order.Element("summ_price").Value))
                                    {
                                        throw new Exception("Суммарная стоимость товаров одного типа и их количество - обязательные поля");
                                    }

                                    int positionsCount = int.Parse(order.Element("positions_count").Value);
                                    int summPrice = int.Parse(order.Element("summ_price").Value);

                                    //это слой продуктов в заказе
                                    foreach (var product in order.Descendants("product"))
                                    {
                                        string productName = product.Element("prod_name").Value;
                                        if (String.IsNullOrWhiteSpace(productName))
                                        {
                                            throw new Exception("Название товара - обязательное поле");
                                        }
                                        else
                                        {
                                            using (var command = new NpgsqlCommand("select prod_id from products where prod_name=@productName", nc))
                                            {
                                                command.Parameters.AddWithValue("productName", productName);
                                                using (var reader = command.ExecuteReader())
                                                {
                                                    if (reader.Read())
                                                    {
                                                        prodId = reader.GetInt32(0);
                                                    }
                                                }
                                            }
                                        }
                                        if (prodId == 0)
                                        {
                                            if (String.IsNullOrWhiteSpace(product.Element("prod_count").Value) || String.IsNullOrWhiteSpace(product.Element("price").Value))
                                            {
                                                throw new Exception("Количество товара на складе и цена за шт. - обязательные поля");
                                            }
                                            else
                                            {
                                                int prodCount = int.Parse(product.Element("prod_count").Value);
                                                int prodPrice = int.Parse(product.Element("price").Value);
                                                string prodDesc = product.Element("description").Value;
                                                using (var command = new NpgsqlCommand("INSERT INTO Products (prod_name, prod_count, price, prod_desc) VALUES (@pn, @pc, @p, @pd) returning prod_id", nc))
                                                {
                                                    command.Parameters.AddWithValue("@pn", productName);
                                                    command.Parameters.AddWithValue("@pc", prodCount);
                                                    command.Parameters.AddWithValue("@p", prodPrice);
                                                    command.Parameters.AddWithValue("@pd", prodDesc);
                                                    prodId = Convert.ToInt32(command.ExecuteScalar());
                                                }
                                                productsCount++;
                                            }
                                        }
                                    }

                                    using (var command = new NpgsqlCommand("INSERT INTO ordercomposition (purchase_id, prod_id, positions_count, summ_price) VALUES (@puid, @prid, @pc, @sp) returning order_comp_id", nc))
                                    {
                                        command.Parameters.AddWithValue("@puid", purchaseId);
                                        command.Parameters.AddWithValue("@prid", prodId);
                                        command.Parameters.AddWithValue("@pc", positionsCount);
                                        command.Parameters.AddWithValue("@sp", summPrice);
                                        orderCompId = Convert.ToInt32(command.ExecuteScalar());
                                    }
                                    ordersCount++;
                                }
                            }

                            foreach (var address in user.Descendants("addresses"))
                            {
                                string currentAddress = address.Element("address").Value;
                                if (String.IsNullOrWhiteSpace(currentAddress))
                                {
                                    throw new Exception("Адрес - обязательное поле");
                                }
                                else
                                {
                                    using (var command = new NpgsqlCommand("INSERT INTO Addresses (user_id, addr) VALUES (@user_id, @addr)", nc))
                                    {
                                        command.Parameters.AddWithValue("@user_id", userId);
                                        command.Parameters.AddWithValue("@addr", currentAddress);
                                        command.ExecuteScalar();
                                    }
                                    addrCount++;
                                }
                            }

                            foreach (var phone in user.Descendants("phones"))
                            {
                                string currentPhone = phone.Element("phone_number").Value;
                                if (String.IsNullOrWhiteSpace(currentPhone))
                                {
                                    throw new Exception("Номер телефона - обязательное поле");
                                }
                                else
                                {
                                    using (var command = new NpgsqlCommand("INSERT INTO phone_numbers (user_id, phone_number) VALUES (@user_id, @pn)", nc))
                                    {
                                        command.Parameters.AddWithValue("@user_id", userId);
                                        command.Parameters.AddWithValue("@pn", currentPhone);
                                        command.ExecuteScalar();
                                    }
                                    phonesCount++;
                                }
                            }
                        }
                    }
                }

                Console.WriteLine("Данные успешно загружены.");
                Console.WriteLine("Количество добавленных пользователей: " + usersCount.ToString());
                Console.WriteLine("Количество добавленных заказов: " + purchasesCount.ToString());
                Console.WriteLine("Количество добавленных чеков: " + ordersCount.ToString());
                Console.WriteLine("Количество добавленных товаров: " + productsCount.ToString());
                Console.WriteLine("Количество добавленных адресов: " + addrCount.ToString());
                Console.WriteLine("Количество добавленных номеров телефонов: " + phonesCount.ToString());
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Произошла ошибка: {ex.Message}");
            }
            nc.Close();
            Console.WriteLine("Если Вы желаете загрузить еще данные в базу, введите 1");
            answer = Console.ReadLine();
        }
        Console.WriteLine("Вы завершили работу с программой");
    }
}
