namespace TP_List
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.txtServerName = new System.Windows.Forms.TextBox();
            this.TxtUserName = new System.Windows.Forms.TextBox();
            this.TxtPassword = new System.Windows.Forms.TextBox();
            this.LBLSERVER = new System.Windows.Forms.Label();
            this.LblUserName = new System.Windows.Forms.Label();
            this.LblPassword = new System.Windows.Forms.Label();
            this.btnCreateExcelFile = new System.Windows.Forms.Button();
            this.TPProgressBar = new System.Windows.Forms.ProgressBar();
            this.lblprogress = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // txtServerName
            // 
            this.txtServerName.Location = new System.Drawing.Point(92, 12);
            this.txtServerName.Name = "txtServerName";
            this.txtServerName.Size = new System.Drawing.Size(282, 20);
            this.txtServerName.TabIndex = 0;
            this.txtServerName.Text = "DATAS\\SQLEXPRESS";
            // 
            // TxtUserName
            // 
            this.TxtUserName.Location = new System.Drawing.Point(92, 48);
            this.TxtUserName.Name = "TxtUserName";
            this.TxtUserName.Size = new System.Drawing.Size(282, 20);
            this.TxtUserName.TabIndex = 1;
            this.TxtUserName.Text = "sa";
            // 
            // TxtPassword
            // 
            this.TxtPassword.Location = new System.Drawing.Point(92, 84);
            this.TxtPassword.Name = "TxtPassword";
            this.TxtPassword.PasswordChar = '*';
            this.TxtPassword.Size = new System.Drawing.Size(282, 20);
            this.TxtPassword.TabIndex = 2;
            this.TxtPassword.Text = "aria_123";
            // 
            // LBLSERVER
            // 
            this.LBLSERVER.AutoSize = true;
            this.LBLSERVER.Location = new System.Drawing.Point(15, 15);
            this.LBLSERVER.Name = "LBLSERVER";
            this.LBLSERVER.Size = new System.Drawing.Size(72, 13);
            this.LBLSERVER.TabIndex = 3;
            this.LBLSERVER.Text = "Server Name:";
            // 
            // LblUserName
            // 
            this.LblUserName.AutoSize = true;
            this.LblUserName.Location = new System.Drawing.Point(24, 51);
            this.LblUserName.Name = "LblUserName";
            this.LblUserName.Size = new System.Drawing.Size(63, 13);
            this.LblUserName.TabIndex = 4;
            this.LblUserName.Text = "User Name:";
            // 
            // LblPassword
            // 
            this.LblPassword.AutoSize = true;
            this.LblPassword.Location = new System.Drawing.Point(31, 87);
            this.LblPassword.Name = "LblPassword";
            this.LblPassword.Size = new System.Drawing.Size(56, 13);
            this.LblPassword.TabIndex = 5;
            this.LblPassword.Text = "Password:";
            // 
            // btnCreateExcelFile
            // 
            this.btnCreateExcelFile.Location = new System.Drawing.Point(120, 135);
            this.btnCreateExcelFile.Name = "btnCreateExcelFile";
            this.btnCreateExcelFile.Size = new System.Drawing.Size(204, 23);
            this.btnCreateExcelFile.TabIndex = 6;
            this.btnCreateExcelFile.Text = "&Create Excel File";
            this.btnCreateExcelFile.UseVisualStyleBackColor = true;
            this.btnCreateExcelFile.Click += new System.EventHandler(this.button1_Click);
            // 
            // TPProgressBar
            // 
            this.TPProgressBar.Location = new System.Drawing.Point(34, 181);
            this.TPProgressBar.Name = "TPProgressBar";
            this.TPProgressBar.Size = new System.Drawing.Size(340, 23);
            this.TPProgressBar.TabIndex = 7;
            // 
            // lblprogress
            // 
            this.lblprogress.AutoSize = true;
            this.lblprogress.Enabled = false;
            this.lblprogress.Location = new System.Drawing.Point(39, 217);
            this.lblprogress.Name = "lblprogress";
            this.lblprogress.Size = new System.Drawing.Size(0, 13);
            this.lblprogress.TabIndex = 8;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(428, 268);
            this.Controls.Add(this.lblprogress);
            this.Controls.Add(this.TPProgressBar);
            this.Controls.Add(this.btnCreateExcelFile);
            this.Controls.Add(this.LblPassword);
            this.Controls.Add(this.LblUserName);
            this.Controls.Add(this.LBLSERVER);
            this.Controls.Add(this.TxtPassword);
            this.Controls.Add(this.TxtUserName);
            this.Controls.Add(this.txtServerName);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "EDI Trading Partner Excel Sheet ...";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtServerName;
        private System.Windows.Forms.TextBox TxtUserName;
        private System.Windows.Forms.TextBox TxtPassword;
        private System.Windows.Forms.Label LBLSERVER;
        private System.Windows.Forms.Label LblUserName;
        private System.Windows.Forms.Label LblPassword;
        private System.Windows.Forms.Button btnCreateExcelFile;
        private System.Windows.Forms.ProgressBar TPProgressBar;
        private System.Windows.Forms.Label lblprogress;
    }
}

