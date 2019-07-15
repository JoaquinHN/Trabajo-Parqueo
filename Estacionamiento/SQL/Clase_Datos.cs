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
    class Clase_Datos
    {
        private string placa;
        private string tipo;
        private string hingreso;
        private int sec;
        public string idAuto;
        private DataTable tabla;

        Clase_Conectar con = new Clase_Conectar();

        public string Placa { get => placa; set => placa = value; }
        public string Tipo { get => tipo; set => tipo = value; }
        public string Hingreso { get => hingreso; set => hingreso = value; }
        public int Sec { get => sec; set => sec = value; }
        public string IdAuto { get => idAuto; set => idAuto = value; }
       

        public Clase_Datos()
        {
            idAuto ="";
            placa = "";
            tipo = "";
            hingreso = "";
            sec =0;
            tabla = new DataTable();
        }
        
         public void buscarplaca()
        {
            try
            {
                con.Abrirconexion();
                if (con.Estado == 1)
                {
                    tabla.Reset();
                    SqlDataAdapter adaptador = new SqlDataAdapter(string.Format("select * from Parqueo.Automovil where placa='{0}'", Placa), con.Conexion);
                    adaptador.Fill(tabla);
                    if (tabla.Rows.Count > 0)
                    {
                        IdAuto = tabla.Rows[0][0].ToString();
                        Sec = 1;
                        Placa = tabla.Rows[0][1].ToString();
                        Tipo = tabla.Rows[0][2].ToString();
                        Hingreso = tabla.Rows[0][3].ToString();
                    }
                    else
                    {
                        Sec = 0;
                        MessageBox.Show("Placa no encontrada");
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}
