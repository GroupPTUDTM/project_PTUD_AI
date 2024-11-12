
namespace GUI
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
            this.control_LogIn1 = new Module_LogIn.control_LogIn();
            this.SuspendLayout();
            // 
            // control_LogIn1
            // 
            this.control_LogIn1.Location = new System.Drawing.Point(1, -20);
            this.control_LogIn1.Name = "control_LogIn1";
            this.control_LogIn1.Size = new System.Drawing.Size(1266, 888);
            this.control_LogIn1.TabIndex = 0;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1257, 832);
            this.Controls.Add(this.control_LogIn1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);

        }

        #endregion

        private Module_LogIn.control_LogIn control_LogIn1;
    }
}

