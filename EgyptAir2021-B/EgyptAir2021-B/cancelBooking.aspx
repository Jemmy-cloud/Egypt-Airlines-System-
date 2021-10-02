<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.master" %>

<%@import Namespace="System.Data.SqlClient" %>
<%@import Namespace="System.Data" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Net" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        
    }



    protected void btnDisplay_Click(object sender, EventArgs e)
    {
       // string strConn = ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
       // SqlConnection conn = new SqlConnection(strConn);

        // create a connection object to the database
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=.\\SQLEXPRESS;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True;User Instance=True";
        

        string username = "";
        if (Request.Cookies["userInfo"] != null)
            username = Request.Cookies["userInfo"].Values["usern"];
        

        // Getting bookings
        string strSelectB = "SELECT B.RefNo, B.FlightNo, B.FlightDate, F.Dairport, F.Dtime, F.Aairport, F.Atime, B.PassengerName, B.SeatNo "
            + " FROM Booking B, Flight F "
            + " WHERE B.FlightNo   = F.FlightNo "
            + " AND   B.FlightDate = F.FlightDate "
            + " AND   B.Username = '" + username + "'"
            + " AND   B.FlightDate >= '" + txtStartDate.Text + "'"
            + " AND   B.FlightDate <= '" + txtEndDate.Text + "'";


        SqlCommand cmdSelectB = new SqlCommand(strSelectB, conn);
        DataTable tbl = new DataTable();
        SqlDataReader reader;
        

        conn.Open();
        reader = cmdSelectB.ExecuteReader();
       
        tbl.Load(reader);
        reader.Close();
          
        reader = cmdSelectB.ExecuteReader();

        if (reader.Read())
        {

            gdvBooking.DataSource = tbl;
            gdvBooking.DataBind();
            gdvBooking.Visible = true;
            btnCancel.Visible = true;
            lblMsg.Text = "";
        }
        else
        {
            lblMsg.Text = "No Booking in such period!!";
            btnCancel.Visible = false;
            gdvBooking.Visible = false;
        }
        conn.Close();
                   

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {

        // create a connection object to the database
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=.\\SQLEXPRESS;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True;User Instance=True";
        
        if (gdvBooking.SelectedIndex != -1)
        {

            lblMsg.Text = "";
            
            // getting Flight key

            int RefNo = Int32.Parse(gdvBooking.SelectedRow.Cells[1].Text);

            string FlightNo = gdvBooking.SelectedRow.Cells[2].Text;
            string FlightDate = gdvBooking.SelectedRow.Cells[3].Text;
            string SeatNo = "";
            SeatNo = gdvBooking.SelectedRow.Cells[9].Text;

            txtFlightDate.Text = FlightDate;

            string Today = DateTime.Now.ToShortDateString();
            txtToday.Text = Today;

            DateTime dt = Convert.ToDateTime(FlightDate);


            TimeSpan t = dt - DateTime.Now;
            double NrOfDays = t.TotalDays;

            txtDiff.Text = NrOfDays.ToString();

            if (NrOfDays < 1)
                lblMsg.Text = "Not Allowed to Cancel the Selected Flight!!";
            else
            {

                btnCancel.Visible = true;
                string username = "";
                string email = "";
                if (Request.Cookies["userInfo"] != null)
                {
                    username = Request.Cookies["userInfo"].Values["usern"];
                    email = Request.Cookies["userInfo"].Values["email"];
                }


               
                string strDelete = "DELETE FROM Booking "
                    + " WHERE RefNo = " + RefNo;

                SqlCommand cmdDelete = new SqlCommand(strDelete, conn);

                conn.Open();
                cmdDelete.ExecuteNonQuery();
                conn.Close();

                //..............................................................
                // Getting bookings
                string strSelectB = "SELECT B.RefNo, B.FlightNo, B.FlightDate, F.Dairport, F.Dtime, F.Aairport, F.Atime, B.PassengerName, B.SeatNo "
                    + " FROM Booking B, Flight F "
                    + " WHERE B.FlightNo   = F.FlightNo "
                    + " AND   B.FlightDate = F.FlightDate "
                    + " AND   B.Username = '" + username + "'"
                    + " AND   B.FlightDate >= '" + txtStartDate.Text + "'"
                    + " AND   B.FlightDate <= '" + txtEndDate.Text + "'";


                SqlCommand cmdSelectB = new SqlCommand(strSelectB, conn);

                DataTable tbl = new DataTable();
                
                conn.Open();
                tbl.Load(cmdSelectB.ExecuteReader());
                gdvBooking.DataSource = tbl;
                gdvBooking.DataBind();
                conn.Close();

                //.....................................................................................................
                // Update Flight Seats
               
                
                string strUpdate2 = "UPDATE FlightSeat "
                   + " SET PassengerName = NULL "
                   + " WHERE FlightNo    = '" + FlightNo + "'"
                   + " AND FlightDate    = '" + FlightDate + "'"
                   + " AND SeatNo = '" + SeatNo + "'";
                   

                SqlCommand cmdUpdate2 = new SqlCommand(strUpdate2, conn);

                conn.Open();
                cmdUpdate2.ExecuteNonQuery();
                conn.Close();

                                       
                
                //..................................................................
                string strMsg = "Your Booking of Reference No: " + RefNo + " on Flight " + FlightNo + " of " + FlightDate + " has been cancelled";

                
                lblMsg.Text = strMsg;
                lblMsg.Visible = true;
                sendEmail(email, strMsg);
                
                // ..........................................................................................
                // Updateing Seats of the Flight

                // Getting RefNo
                string strSelectS = "SELECT Seats FROM Flight"
                    + " WHERE FlightNo = '" + FlightNo + "'"
                    + " AND FlightDate = '" + FlightDate + "'";

                SqlCommand cmdSelectS = new SqlCommand(strSelectS, conn);

                SqlDataReader reader;

                conn.Open();
                reader = cmdSelectS.ExecuteReader();

                int Seats = 0;
                if (reader.Read())
                    Seats = (int)reader.GetValue(0);
                reader.Close();
                conn.Close();

                Seats = Seats + 1;


                string strUpdateS = "Update Flight "
                    + " SET Seats = " + Seats
                    + " WHERE FlightNo = '" + FlightNo + "'"
                    + " AND FlightDate = '" + FlightDate + "'";
                   

                SqlCommand cmdUpdateS = new SqlCommand(strUpdateS, conn);
                
                conn.Open();
                cmdUpdateS.ExecuteNonQuery();
                conn.Close();
                
                //...........................................................................................
                             

            }

        }
        else
            lblMsg.Text = "No Booking Selected!! Select a Booking, then Click the Button Cancel!!";    
             
             
    }

        
    protected void sendEmail(string strEmail, string strMsg)
    {

        MailMessage msg = new MailMessage("CSCE4502@gmail.com", strEmail);
        msg.Subject = "Booking Cancellation";
        msg.Body = strMsg;

        SmtpClient Sclient = new SmtpClient("smtp.gmail.com", 587);
        NetworkCredential auth = new NetworkCredential("CSCE4502@gmail.com", "csce4502f16");

        Sclient.UseDefaultCredentials = false;
        Sclient.Credentials = auth;
        Sclient.EnableSsl = true;
        try
        {
            Sclient.Send(msg);
           
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style14
    {
        width: 71%;
    }
    .style15
    {
        width: 367px;
            height: 51px;
        }
        .style17
        {
            height: 51px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>


        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
</p>
    <p>


    <asp:Label ID="Label1" runat="server" Font-Names="Arial Black" 
        Font-Size="Medium" ForeColor="#000066" Text="Booking List:"></asp:Label>
    <br />
</p>
<table class="style14">
    <tr>
        <td class="style15">
            <asp:Label ID="Label2" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" ForeColor="#000066" Text="From Date:"></asp:Label>
&nbsp;&nbsp;
            <asp:TextBox ID="txtStartDate" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtStartDate_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" TargetControlID="txtStartDate">
            </ajaxToolkit:CalendarExtender>
        </td>
        <td class="style17">
            <asp:Label ID="Label3" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" ForeColor="#000066" Text="To Date:"></asp:Label>
&nbsp;
            <asp:TextBox ID="txtEndDate" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtEndDate_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" TargetControlID="txtEndDate">
            </ajaxToolkit:CalendarExtender>
        </td>
    </tr>
</table>
    &nbsp;&nbsp;
    <br />
            <asp:Button ID="btnDisplay" runat="server" Font-Names="Arial Black" 
        Font-Size="Medium" ForeColor="#000066" onclick="btnDisplay_Click" 
        Text="Display" />
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtToday" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066" Visible="False"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtToday_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" 
        TargetControlID="txtToday">
            </ajaxToolkit:CalendarExtender>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtFlightDate" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066" Visible="False"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtFlightDate_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" 
        TargetControlID="txtFlightDate">
            </ajaxToolkit:CalendarExtender>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtDiff" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066" Visible="False"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtDiff_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" 
        TargetControlID="txtDiff">
            </ajaxToolkit:CalendarExtender>
    <br />
    <br />
   
                    <asp:GridView ID="gdvBooking" runat="server" CellPadding="4" Font-Names="Arial" 
                        Font-Size="Medium" ForeColor="#000066" GridLines="None">
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        <Columns>
                            <asp:CommandField HeaderText="Select" ShowHeader="True" 
                                ShowSelectButton="True" />
                        </Columns>
                        <EditRowStyle BackColor="#999999" />
                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        <SortedAscendingCellStyle BackColor="#E9E7E2" />
                        <SortedAscendingHeaderStyle BackColor="#506C8C" />
                        <SortedDescendingCellStyle BackColor="#FFFDF8" />
                        <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                    </asp:GridView>
            <br />
                    <asp:Label ID="lblMsg" runat="server" Font-Names="Monotype Corsiva" 
                        Font-Size="X-Large" ForeColor="#000066"></asp:Label>
            <br />
              
    <br />
            <asp:Button ID="btnCancel" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" onclick="btnCancel_Click" Text="Cancel" Visible="False" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="lblRefNo" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" Visible="False"></asp:Label>
    <br />
    <br />
    
        
    <br />
    </asp:Content>

