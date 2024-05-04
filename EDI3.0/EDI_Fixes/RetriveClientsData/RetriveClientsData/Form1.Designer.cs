namespace RetriveClientsData
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
            System.Windows.Forms.Button btn_ModifyData;
            this.cmb_ServerName = new System.Windows.Forms.ComboBox();
            this.cmb_Authentication = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.txt_UserName = new System.Windows.Forms.TextBox();
            this.txt_Password = new System.Windows.Forms.TextBox();
            this.lblProgress = new System.Windows.Forms.Label();
            btn_ModifyData = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btn_ModifyData
            // 
            btn_ModifyData.Location = new System.Drawing.Point(252, 76);
            btn_ModifyData.Name = "btn_ModifyData";
            btn_ModifyData.Size = new System.Drawing.Size(107, 23);
            btn_ModifyData.TabIndex = 11;
            btn_ModifyData.Text = "Modify Client Data";
            btn_ModifyData.UseVisualStyleBackColor = true;
            btn_ModifyData.Click += new System.EventHandler(this.btn_ModifyData_Click);
            // 
            // cmb_ServerName
            // 
            this.cmb_ServerName.FormattingEnabled = true;
            this.cmb_ServerName.Location = new System.Drawing.Point(103, 12);
            this.cmb_ServerName.Name = "cmb_ServerName";
            this.cmb_ServerName.Size = new System.Drawing.Size(267, 21);
            this.cmb_ServerName.TabIndex = 2;
            // 
            // cmb_Authentication
            // 
            this.cmb_Authentication.FormattingEnabled = true;
            this.cmb_Authentication.Items.AddRange(new object[] {
            "Windows Authentication",
            "SQL Server Authentication"});
            this.cmb_Authentication.Location = new System.Drawing.Point(103, 39);
            this.cmb_Authentication.Name = "cmb_Authentication";
            this.cmb_Authentication.Size = new System.Drawing.Size(267, 21);
            this.cmb_Authentication.TabIndex = 3;
            this.cmb_Authentication.SelectedIndexChanged += new System.EventHandler(this.cmb_Authentication_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(16, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(76, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Server Name :";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(16, 43);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(84, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Authentication :";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(18, 72);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(66, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "User Name :";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(19, 97);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(60, 13);
            this.label4.TabIndex = 7;
            this.label4.Text = "Password :";
            // 
            // txt_UserName
            // 
            this.txt_UserName.Enabled = false;
            this.txt_UserName.Location = new System.Drawing.Point(104, 69);
            this.txt_UserName.Name = "txt_UserName";
            this.txt_UserName.Size = new System.Drawing.Size(105, 20);
            this.txt_UserName.TabIndex = 8;
            // 
            // txt_Password
            // 
            this.txt_Password.Enabled = false;
            this.txt_Password.Location = new System.Drawing.Point(104, 94);
            this.txt_Password.Name = "txt_Password";
            this.txt_Password.PasswordChar = '*';
            this.txt_Password.Size = new System.Drawing.Size(105, 20);
            this.txt_Password.TabIndex = 9;
            // 
            // lblProgress
            // 
            this.lblProgress.AutoSize = true;
            this.lblProgress.Location = new System.Drawing.Point(20, 122);
            this.lblProgress.Name = "lblProgress";
            this.lblProgress.Size = new System.Drawing.Size(0, 13);
            this.lblProgress.TabIndex = 12;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(415, 149);
            this.Controls.Add(this.lblProgress);
            this.Controls.Add(btn_ModifyData);
            this.Controls.Add(this.txt_Password);
            this.Controls.Add(this.txt_UserName);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cmb_Authentication);
            this.Controls.Add(this.cmb_ServerName);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cmb_ServerName;
        private System.Windows.Forms.ComboBox cmb_Authentication;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txt_UserName;
        private System.Windows.Forms.TextBox txt_Password;
        private System.Windows.Forms.Label lblProgress;

    }
}

