using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using Estacionamiento.SQL;
using System.Data;
using System.Data.SqlClient;

namespace Estacionamiento
{
    /// <summary>
    /// Lógica de interacción para Window1.xaml
    /// </summary>
    public partial class Window1 : Window
    {
        private int idauto;
        Clase_Conectar conexion = new Clase_Conectar();
        private DataTable tabla;
        public Window1()
        {
            InitializeComponent();
            tabla = new DataTable();
            try
            {
                conexion.Abrirconexion();
                if (conexion.Estado == 1)
                {

                    string query = "SELECT tipoVehiculo, idTipo FROM Parqueo.TipoAutomovil";
                    SqlDataAdapter adaptador = new SqlDataAdapter(query, conexion.Conexion);
                    using (adaptador)
                    {
                        adaptador.Fill(tabla);
                        cmbtipo.DisplayMemberPath = "tipoVehiculo";
                        cmbtipo.SelectedValuePath = "idTipo";
                        cmbtipo.ItemsSource = tabla.DefaultView;
                    }
                }
            }
            catch (Exception e)
            {

                MessageBox.Show(e.ToString());
            }
        }

        public int Idauto { get => idauto; set => idauto = value; }

        private void Btningresar_Click(object sender, RoutedEventArgs e)
        {
            if (txtplaca.Text != "")
            {
                try
                {
                    conexion.Abrirconexion();
                    if (conexion.Estado == 1)
                    {


                        string query = string.Format("AGREGARAUTO");
                        SqlCommand comando = new SqlCommand(query, conexion.Conexion);
                        comando.CommandType = CommandType.StoredProcedure;
                        SqlDataAdapter adaptador = new SqlDataAdapter(comando);
                        using (adaptador)
                        {
                            comando.Parameters.AddWithValue("@placa", txtplaca.Text);
                            comando.Parameters.AddWithValue("@idtipovehiculo",cmbtipo.SelectedValue);
                            comando.ExecuteNonQuery();
                            MessageBox.Show(" Gracias por preferirnos");
                        }
                    }
                }
                catch (Exception ex)
                {

                    MessageBox.Show(" Datos No Insertado" + ex.Message);
                }
                finally
                {
                    txtplaca.Text = string.Empty;
                    cmbtipo.SelectedValue = null;
                }
            }
        }
    }
}
