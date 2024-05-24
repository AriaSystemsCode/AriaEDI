using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Shopify_Product_Reader;

namespace Shopify_ImportProduct_Test
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            Shopify_Product_Reader.Main main = new Main();
            main.Do(this.textBox1.Text,
                this.textBox2.Text,
                this.textBox3.Text,
                this.textBox4.Text,
                this.textBox5.Text,
                this.textBox6.Text,
                this.textBox7.Text);

            //xx.Do(@"C:\Users\Hassan.I\source\Workspaces\Workspace\EDI\EDI3.0\EDI_Tool\.Net Tools\EDI_VAN\variants\variants.xml",
            //    "edisql",
            //    "sa",
            //    "aria_123",
            //    "LAF00_LDB01",
            //    "LAF00.Master",
            //    "SHPIT");
            //for (int i = 1; i < 10; i++)
            //{
            //    xx.Do(@"C:\Users\Hassan.I\source\Workspaces\Workspace\EDI\EDI3.0\EDI_Tool\.Net Tools\EDI_VAN\variants\variants (" + i.ToString() + ").xml",
            //    "edisql",
            //    "sa",
            //    "aria_123",
            //    "LAF00_LDB01",
            //    "LAF00.Master",
            //    "SHPIT");
            //}



        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.textBox1.Text = @"C:\Users\Hassan.I\source\Workspaces\Workspace\EDI\EDI3.0\EDI_Tool\.Net Tools\EDI_VAN\products.xml";
            this.textBox2.Text = "edisql";
            this.textBox3.Text = "sa";
            this.textBox4.Text = "aria_123";
            this.textBox5.Text = "LAF00_LDB01";
            this.textBox6.Text = "LAF00.Master";
            this.textBox7.Text = "SHPIT";
        }
    }
}
