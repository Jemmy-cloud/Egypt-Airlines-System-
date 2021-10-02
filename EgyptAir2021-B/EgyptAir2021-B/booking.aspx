<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.master" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Net" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        txtStartDate_CalendarExtender.StartDate = DateTime.Today;
        txtEndDate_CalendarExtender.StartDate = DateTime.Today;

    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
            
        
        // create a connection object to the database
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";


       // lblMsg.Visible = false;
       // gdvBooking.Visible = false;

        string username = "";
        if (Request.Cookies["userInfo"] != null)
            username = Request.Cookies["userInfo"].Values["usern"];
        ViewState["U"] = username;

        // Getting Flights
         string strSelectF = "SELECT FlightNo, CONVERT(varchar(10), FlightDate, 101) as FlightDate, "
            + " Dairport, Dtime, Aairport, Atime, Seats "
            + "  FROM Flight "
            + " WHERE FlightDate >= '" + txtStartDate.Text + "'"
            + " AND   FlightDate <= '" + txtEndDate.Text + "'"
            + " AND   Dairport  = '" + ddlDairport.SelectedValue + "'"
            + " AND   Aairport  = '" + ddlAairport.SelectedValue + "'"
            + " AND   Seats > 0";
        
         SqlCommand cmdSelectF = new SqlCommand(strSelectF, conn);
         
      //  Craeting Data Table
        
        DataTable tbl = new DataTable();
        
        conn.Open();
    
        tbl.Load(cmdSelectF.ExecuteReader()); 
        gdvFlight.DataSource = tbl;
        gdvFlight.DataBind();

        if (gdvFlight.Rows.Count != 0)
        {
        //    gdvFlight.Visible = true;
        btnBook.Visible = true;
        txtPassengerName.Visible = true;
        lblPassengerName.Visible = true;
       lblMsg.Text = "Select a Flight, Enter Passenger Name, then Click Book";

       
        }
        else
         {
            lblMsg.Text = "No Available Flights, You May Change Your Preferences!!";
           
              btnBook.Visible = false;
              txtPassengerName.Visible = false;
              lblPassengerName.Visible = false;
    
          }  
            conn.Close();
        
    }


    protected void btnBook_Click(object sender, EventArgs e)
    {
         lblMsg.Text = "";
          lblMsg2.Text = "";

        if (gdvFlight.SelectedIndex != -1)
        {

            // create a connection object to the database
           SqlConnection conn = new SqlConnection();
           conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";

            string username = "";
            string email = "";
            if (Request.Cookies["userInfo"] != null)
            {
                username = Request.Cookies["userInfo"].Values["usern"];
                email = Request.Cookies["userInfo"].Values["email"];
            }
            
            ViewState["U"] = username;


            // getting selected Flight data
            string FlightNo = gdvFlight.SelectedRow.Cells[1].Text;
            string FlightDate = gdvFlight.SelectedRow.Cells[2].Text;
            string Dtime = gdvFlight.SelectedRow.Cells[4].Text;
            string Atime = gdvFlight.SelectedRow.Cells[6].Text;

                   
            // Getting highest RefNo value
            string strSelect = "SELECT MAX(RefNo) FROM Booking";

            SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

            SqlDataReader reader;

            conn.Open();
            reader = cmdSelect.ExecuteReader();

            int RefNo = 0;
            if (reader.Read())
                RefNo = (int)reader.GetValue(0);
            reader.Close();
            conn.Close();

            Random rnd = new Random();
            int incr = rnd.Next(100, 10000); // creates a number between 1 and 100

            RefNo = RefNo + incr;


            string strInsert = String.Format("Insert Into Booking Values({0},'{1}','{2}', '{3}', '{4}', '{5}')", RefNo, username, FlightNo, FlightDate, txtPassengerName.Text, null);

            SqlCommand cmdInsert = new SqlCommand(strInsert, conn);


            conn.Open();
            cmdInsert.ExecuteNonQuery();
            conn.Close();


            // display current booking
            gdvBooking.Visible = true;
            lblCurrent.Visible    = true;

            // Getting bookings
            string strSelectB = "SELECT B.RefNo, B.FlightNo, CONVERT(varchar(10), B.FlightDate, 101) as FlightDate, F.Dairport, F.Dtime, F.Aairport, F.Atime, B.PassengerName, B.SeatNo "
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


            string strBook = "Thanks for using EgyptAir Airlines. This is to confirm your booking of a seat for "
            + txtPassengerName.Text + " in our Flight " + FlightNo + " on " + FlightDate + "'\n'"
            + " Departure from  " + ddlDairport.SelectedValue + " at " + Dtime + "'\n'"
            + " Arrival to " + ddlAairport.SelectedValue + " at " + Atime + "'\n'"
            + "Your Reference No: " + RefNo;

            sendEmail(email, strBook);

            // Updating seats of selected Flight

            string strUpdate = "UPDATE Flight "
                + " SET Seats = Seats - 1 "
                + " WHERE FlightNo = '" + FlightNo + "'"
                + " AND   FlightDate = '" + FlightDate + "'";

            SqlCommand cmdUpdate = new SqlCommand(strUpdate, conn);


            conn.Open();
            cmdUpdate.ExecuteNonQuery();
            conn.Close();

            //+++++++++++++++++++++++++++++++++++
            // updating Flights
            // Getting Flights
            string strSelectF2 = "SELECT * FROM Flight "
               + " WHERE FlightDate >= '" + txtStartDate.Text + "'"
               + " AND   FlightDate <= '" + txtEndDate.Text + "'"
               + " AND   Dairport  = '" + ddlDairport.SelectedValue + "'"
               + " AND   Aairport  = '" + ddlAairport.SelectedValue + "'"
               + " AND   Seats > 0";

            SqlCommand cmdSelectF2 = new SqlCommand(strSelectF2, conn);

            DataTable tbl2 = new DataTable();

            conn.Open();
            tbl2.Load(cmdSelectF2.ExecuteReader());
            gdvFlight.DataSource = tbl2;
            gdvFlight.DataBind();
            
           //++++++++++++++++++++++++++++++++++
            
            btnConfirm.Visible = true;
            
        }
        else
        {
            lblMsg.Text = "No Flight Selected!! Select a Flight, then Click the Button Book!!";
            lblMsg.Visible = true;
        }


    }
    
    protected void sendEmail(string strEmail, string strMsg)
    {

        MailMessage msg = new MailMessage("CSCE4502@gmail.com", strEmail);
        msg.Subject = "Booking Confirmation";
        msg.Body = strMsg;

        SmtpClient Sclient = new SmtpClient("smtp.gmail.com", 587);
        NetworkCredential auth = new NetworkCredential("CSCE4502@gmail.com", "csce4502f16");

        Sclient.UseDefaultCredentials = false;
        Sclient.Credentials = auth;
        Sclient.EnableSsl = true;
        try
        {
            Sclient.Send(msg);
            lblMsg.Text = "A Message has been sent to your Email Address with details of your booking!!";
            lblMsg.Visible = true;
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }

    }
    
protected void  btnConfirm_Click(object sender, EventArgs e)
{
    gdvBooking.Visible = false;
    gdvFlight.Visible = true;
    lblMsg.Visible = false;
   

    btnConfirm.Visible = false;
    btnBook.Visible = false;
    txtPassengerName.Visible = false;
    lblPassengerName.Visible = false;
    lblCurrent.Visible = false;
    txtStartDate.Text = "";
    txtEndDate.Text = "";

        lblMsg2.Visible = true;
        lblMsg2.Text = "Your booking has been confirmed, do another or click User Home to exit,,";
}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <br />
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <br />
    <asp:Label ID="Label4" runat="server" Font-Names="Arial Black" Font-Size="Medium" 
        ForeColor="#000066" Text="Enter Your Preferences:"></asp:Label>
    <br />
    <br />
    <asp:Label ID="Label1" runat="server" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066" Text="FromDate:"></asp:Label>
&nbsp;<asp:TextBox ID="txtStartDate" runat="server" Font-Names="Arial" 
        Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
    <asp:CalendarExtender ID="txtStartDate_CalendarExtender" runat="server" 
        Enabled="True" TargetControlID="txtStartDate">
    </asp:CalendarExtender>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Label ID="Label2" runat="server" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066" Text="To Date:"></asp:Label>
&nbsp;
    <asp:TextBox ID="txtEndDate" runat="server" Font-Names="Arial" 
        Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
    <asp:CalendarExtender ID="txtEndDate_CalendarExtender" runat="server" 
        Enabled="True" TargetControlID="txtEndDate">
    </asp:CalendarExtender>
    <br />
    <br />
    <asp:Label ID="Label3" runat="server" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066" Text="Departure From:"></asp:Label>
&nbsp;<asp:DropDownList ID="ddlDairport" runat="server" 
        DataSourceID="SqlDataSource1" DataTextField="Dairport" 
        DataValueField="Dairport" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066">
    </asp:DropDownList>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Label ID="Label5" runat="server" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066" Text="Destination:"></asp:Label>
&nbsp;<asp:DropDownList ID="ddlAairport" runat="server" 
        DataSourceID="SqlDataSource2" DataTextField="Aairport" 
        DataValueField="Aairport" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        SelectCommand="SELECT DISTINCT [Aairport] FROM [Flight]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        SelectCommand="SELECT DISTINCT [Dairport] FROM [Flight]">
    </asp:SqlDataSource>
    <br />
    <br />
    <asp:Button ID="btnSubmit" runat="server" Font-Bold="True" 
        Font-Names="Arial Black" Font-Size="Medium" ForeColor="#000066" 
        onclick="btnSubmit_Click" Text="Display Available Flights" />
    <br />
    <br />
    <asp:GridView ID="gdvFlight" runat="server" CellPadding="4" Font-Names="Arial" 
        Font-Size="Medium" ForeColor="#000066" GridLines="None">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:CommandField ShowSelectButton="True" />
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

<SortedAscendingCellStyle BackColor="#E9E7E2"></SortedAscendingCellStyle>

<SortedAscendingHeaderStyle BackColor="#506C8C"></SortedAscendingHeaderStyle>

<SortedDescendingCellStyle BackColor="#FFFDF8"></SortedDescendingCellStyle>

<SortedDescendingHeaderStyle BackColor="#6F8DAE"></SortedDescendingHeaderStyle>
    </asp:GridView>
    <br />
    <br />
    <asp:Label ID="lblPassengerName" runat="server" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066" Text="Passenger Name:" Visible="False"></asp:Label>
&nbsp;
    <asp:TextBox ID="txtPassengerName" runat="server" Font-Names="Arial" 
        Font-Size="Medium" ForeColor="#000066" Visible="False"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="btnBook" runat="server" Font-Bold="True" 
        Font-Names="Arial Black" Font-Size="Medium" ForeColor="#000066" Text="Book" 
        Visible="False" onclick="btnBook_Click" />
    <br />
    <br />
    <asp:Label ID="lblMsg" runat="server" Font-Names="Monotype Corsiva" Font-Size="X-Large" 
        ForeColor="#CC0000" Font-Bold="True"></asp:Label>
    <br />
    <br />
    <br />
    <asp:Label ID="lblCurrent" runat="server" Font-Names="Arial Black" Font-Size="Medium" 
        ForeColor="#000066" Text="Current Bookings:" Visible="False"></asp:Label>
    <br />
    <asp:GridView ID="gdvBooking" runat="server" CellPadding="4" Font-Names="Arial" 
        Font-Size="Medium" ForeColor="#000066" GridLines="None">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:CommandField />
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

<SortedAscendingCellStyle BackColor="#E9E7E2"></SortedAscendingCellStyle>

<SortedAscendingHeaderStyle BackColor="#506C8C"></SortedAscendingHeaderStyle>

<SortedDescendingCellStyle BackColor="#FFFDF8"></SortedDescendingCellStyle>

<SortedDescendingHeaderStyle BackColor="#6F8DAE"></SortedDescendingHeaderStyle>
    </asp:GridView>
    <br />
    <asp:Button ID="btnConfirm" runat="server" Font-Names="Arial Black" 
        Font-Size="Medium" ForeColor="#000066" onclick="btnConfirm_Click" 
        Text="Confirm Your Booking" Visible="False" />
    <br />
    <br />
    <asp:Label ID="lblMsg2" runat="server" Font-Names="Monotype Corsiva" Font-Size="X-Large" 
        ForeColor="#CC0000" Font-Bold="True" Visible="False"></asp:Label>
    <br />
</asp:Content>

