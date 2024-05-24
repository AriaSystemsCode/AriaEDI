using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace EDI_VAN_LIB
{
    class Mail
    {
        /// <summary>
        /// Send an email from [DELETED]
        /// </summary>
        /// <param name="to">Message to address</param>
        /// <param name="body">Text of message to send</param>
        /// <param name="subject">Subject line of message</param>
        /// <param name="fromAddress">Message from address</param>
        /// <param name="fromDisplay">Display name for "message from address"</param>
        /// <param name="credentialUser">User whose credentials are used for message send</param>
        /// <param name="credentialPassword">User password used for message send</param>
        /// <param name="attachments">Optional attachments for message</param>

        public static void Email(
                                 string body,
                                 string subject,
                                 string email,
                                 string emailPassword,
                                 string emailTo,
                                 string emailCC,
                                 string emailCC1,
                                 string emailDisplayName,
                                 params MailAttachment[] attachments)
        {
            //string host = ConfigurationSettings.AppSettings["SMTPHost"];
            string host = "smtp.gmail.com";
            //string email = ConfigurationSettings.AppSettings["Email"];
            //string password = ConfigurationSettings.AppSettings["EmailPassword"];
            //string to = ConfigurationSettings.AppSettings["To"];
            //string cc = ConfigurationSettings.AppSettings["CC"];
            //string cc1 = ConfigurationSettings.AppSettings["CC1"];
            //string Display_Name = ConfigurationSettings.AppSettings["DisplayName"];

            try
            {
                MailMessage mail = new MailMessage();
                mail.Body = body;
                mail.IsBodyHtml = true;
                mail.To.Add(new MailAddress(emailTo));
                mail.From = new MailAddress(email, emailDisplayName, Encoding.UTF8);
                mail.Subject = subject;
                mail.SubjectEncoding = Encoding.UTF8;
                mail.Priority = MailPriority.Normal;
                if (!string.IsNullOrEmpty(emailCC))
                {
                    MailAddress copy = new MailAddress(emailCC);
                    mail.CC.Add(copy);
                }

                if (!string.IsNullOrEmpty(emailCC1))
                {
                    MailAddress copy = new MailAddress(emailCC1);
                    mail.CC.Add(copy);
                }

                foreach (MailAttachment ma in attachments)
                {
                    mail.Attachments.Add(ma.File);
                }
                SmtpClient smtp = new SmtpClient();
                smtp.Credentials = new System.Net.NetworkCredential(email, emailPassword);
                smtp.Host = host;
                smtp.Port = 587;
                smtp.EnableSsl = true;
                smtp.Send(mail);

            }
            catch (Exception ex)
            {
                StringBuilder stringBuilder = new StringBuilder(1024);
                stringBuilder.Append("\nTo:" + emailTo);
                stringBuilder.Append("\nbody:" + body);
                stringBuilder.Append("\nsubject:" + subject);
                stringBuilder.Append("\nfromAddress:" + email);
                stringBuilder.Append("\nfromDisplay:" + emailDisplayName);
                stringBuilder.Append("\ncredentialUser:" + email);
                stringBuilder.Append("\ncredentialPasswordto:" + emailPassword);
                stringBuilder.Append("\nHosting:" + host);
                //WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + ex.Message.ToString(), 103, 0);

            }
        }
    }
}
