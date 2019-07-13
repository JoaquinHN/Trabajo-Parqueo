using System;
using System.Collections.Generic;
using System.Globalization;
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
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;
using System.Data;
using System.Data.SqlClient;
using Estacionamiento.SQL;

namespace Estacionamiento
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private int idauto;
        Clase_Conectar conexion = new Clase_Conectar();
        private DataTable tabla;
        public MainWindow()
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
            MostrarAutos();
        }

        private void Btnentrada_Click(object sender, RoutedEventArgs e)
        {
            Window1 win = new Window1();
            win.Owner = this;
            win.Show();
        }

        private void Btnsalida_Click(object sender, RoutedEventArgs e)
        {
            Window2 win2 = new Window2();
            win2.Show();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
        }

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
                            comando.Parameters.AddWithValue("@idtipovehiculo", cmbtipo.SelectedValue);
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
                    MostrarAutos();
                }
            }
        }

        private void Cmbtipo_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void MostrarAutos()
        {
            try
            {
                string query = "SELECT * FROM Parqueo.Automovil";
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, conexion.Conexion);
                using (sqlDataAdapter)
                {
                    DataTable tablaAuto = new DataTable();
                    sqlDataAdapter.Fill(tablaAuto);
                    lbMostrarAutos.DisplayMemberPath = "placa";
                    lbMostrarAutos.SelectedValuePath = "idAuto";
                    lbMostrarAutos.ItemsSource = tablaAuto.DefaultView;
                }
            }
            catch (Exception e)
            {

                MessageBox.Show(e.ToString());
            }
        }
    }
}
