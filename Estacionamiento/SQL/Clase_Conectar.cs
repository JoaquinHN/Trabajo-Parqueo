using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Windows;

namespace Estacionamiento.SQL
{

    class Clase_Conectar
    {
        private SqlConnection conexion;
        private int estado;

        public SqlConnection Conexion { get => conexion; set => conexion = value; }
        public int Estado { get => estado; set => estado = value; }

        public Clase_Conectar()
        {
            conexion = new SqlConnection();
            estado = 0;
        }

        public SqlConnection Abrirconexion()
        {
            try
            {
                if (conexion.State == ConnectionState.Open)
                {
                    conexion.Close();
                    Estado = 0;

                }
                if (conexion.State == ConnectionState.Closed)
                {
                    conexion.ConnectionString = string.Format(@"server = (local)\sqlexpress; database=Estacionamiento ;integrated security = true;");
                    conexion.Open();
                    Estado = 1;
                }
                return conexion;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                Estado = 0;
                return conexion;
            }
        }
    }
}
