using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace test_skrin
{
    public static class ConnectToDB
    {
        public static NpgsqlConnection connect()
        {
            string connString = "Server=localhost;Port=5432;Username=postgres;Password=nastya123;Database=test_skrin";
            NpgsqlConnection nc = new NpgsqlConnection(connString);
            try
            {
                //Открываем соединение.
                nc.Open();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Ошибка при подключении к БД"+ex.Message);
            }
            return nc;
        }
    }
}
