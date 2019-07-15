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
using System.Timers;

namespace Estacionamiento
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        Clase_Conectar conexion = new Clase_Conectar();
        Clase_Datos dat = new Clase_Datos();
        private DataTable tabla;

        private int htotal;
        private int hingreso;
        private int hsalida;
        private int idauto;

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
            MostrarHora();
            

            DispatcherTimer dispatcher = new DispatcherTimer();
            dispatcher.Interval = new TimeSpan(0, 0, 1);
            dispatcher.Tick += (s, a) =>
            {
                txthentrada.Text = DateTime.Now.ToString("hh:mm:ss.ms");
                txths.Text = DateTime.Now.ToString("hh:mm:ss.ms");
                
            };
            dispatcher.Start();

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


                        string query = string.Format("AGREGARAUTOS");
                        SqlCommand comando = new SqlCommand(query, conexion.Conexion);
                        comando.CommandType = CommandType.StoredProcedure;
                        SqlDataAdapter adaptador = new SqlDataAdapter(comando);
                        using (adaptador)
                        {
                            comando.Parameters.AddWithValue("@placa", txtplaca.Text);
                            comando.Parameters.AddWithValue("@horaEntrada", txthentrada.Text);
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
                    lbAutos.DisplayMemberPath = "placa";
                    lbMostrarAutos.SelectedValuePath = "idAuto";
                    lbAutos.SelectedValuePath = "idAuto";
                    lbMostrarAutos.ItemsSource = tablaAuto.DefaultView;
                    lbAutos.ItemsSource = tablaAuto.DefaultView;
                }
            }
            catch (Exception e)
            {

                MessageBox.Show(e.ToString());
            }
        }
        private void MostrarHora()
        {
        }

        private void BtnCobro_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                conexion.Abrirconexion();
                if (conexion.Estado == 1)
                {


                    string query = string.Format("AGREGARTRAN");
                    SqlCommand comando = new SqlCommand(query, conexion.Conexion);
                    comando.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter adaptador = new SqlDataAdapter(comando);
                    using (adaptador)
                    {
                        comando.Parameters.AddWithValue("@cobro", txttotal.Text);
                        comando.Parameters.AddWithValue("@horaSalida", txths.Text);
                        comando.Parameters.AddWithValue("@IdAuto", txtidauto.Text);
                        comando.ExecuteNonQuery();
                        MessageBox.Show(" Gracias por preferirnos");
                    }
                }
            }
            catch (Exception ex)
            {

                MessageBox.Show(" Datos No Insertado" + ex.Message);
            }


        }

        private void BtnBuscar_Click(object sender, RoutedEventArgs e)
        {
            if (txtpla.Text == "")
            {
                MessageBox.Show("Ingrese una Placa");
                txtpla.Focus();
            }
            else if (txtpla.Text != "")
            {
                dat.Placa = txtpla.Text;
                dat.buscarplaca();
                if (dat.Sec == 1)
                {
                    txtpla.Text = dat.Placa;
                    txttip.Text = dat.Tipo;
                    txthingre.Text = dat.Hingreso;
                    txtidauto.Text = dat.IdAuto;
                }
                //f
                TimeSpan diferenciahoras = new TimeSpan();
                DateTime horaingreso = new DateTime();
                horaingreso = DateTime.Parse(txthingre.Text);

                DateTime horasalida = new DateTime();
                horasalida = DateTime.Parse(txths.Text);

                diferenciahoras = horasalida - horaingreso;
                int horas = diferenciahoras.Hours;
                double horastotales = diferenciahoras.TotalHours;

                txthtotal.Text = Convert.ToString(diferenciahoras);

                if(txttip.Text=="1" || txttip.Text=="2" || txttip.Text=="3")
                {
                    if(horastotales>=0 && horastotales<=1)
                    {
                        txttotal.Text = "20";
                    }
                    if(horastotales>1 && horastotales<=2)
                    {
                        double s = 20+10;
                        txttotal.Text = Convert.ToString(s);
                    }
                    if (horastotales > 2 && horastotales <= 4)
                    {
                        double s = (20*3)+10;
                        txttotal.Text = Convert.ToString(s); ;
                    }
                    if(horastotales>=4)
                    {
                        double s = horastotales * 15;
                        txttotal.Text = Convert.ToString(s);
                    }
                }
                if(txttip.Text == "4" || txttip.Text == "5" || txttip.Text == "6")
                {
                    if (horastotales >= 0 && horastotales <= 1)
                    {
                        double s = 20 *2;
                        txttotal.Text = Convert.ToString(s);
                    }
                    if (horastotales > 1 && horastotales <= 2)
                    {
                        double s = (20 + 10)*2;
                        txttotal.Text = Convert.ToString(s);
                    }
                    if (horastotales > 2 && horastotales <= 4)
                    {
                        double s = ((20 * 3) + 10)*2;
                        txttotal.Text = Convert.ToString(s); ;
                    }
                    if (horastotales >= 4)
                    {
                        double s = (horastotales * 15)*2;
                        txttotal.Text = Convert.ToString(s);
                    }
                }
                if(txttip.Text=="7")
                {
                    if (horastotales >= 0 && horastotales <= 1)
                    {
                        double s = (20)/2 ;
                        txttotal.Text = Convert.ToString(s);
                    }
                    if (horastotales > 1 && horastotales <= 2)
                    {
                        double s = (20 + 10)/2;
                        txttotal.Text = Convert.ToString(s);
                    }
                    if (horastotales > 2 && horastotales <= 4)
                    {
                        double s = ((20 * 3) + 10)/2;
                        txttotal.Text = Convert.ToString(s); ;
                    }
                    if (horastotales >= 4)
                    {
                        double s = (horastotales * 15) /2;
                        txttotal.Text = Convert.ToString(s);
                    }

                }

            }
        }

        private void Txthtotal_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
    }
}


    
        

