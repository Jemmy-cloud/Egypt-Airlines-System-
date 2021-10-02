<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.master" %>
<%@import Namespace="System.Data.SqlClient" %>
<%@import Namespace="System.Data" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Net" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        txtStartDate_CalendarExtender.StartDate = DateTime.Today;
        txtEndDate_CalendarExtender.StartDate = DateTime.Today;

    }



    protected void btnDisplay_Click(object sender, EventArgs e)
    {
        //string strConn = ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
        //SqlConnection conn = new SqlConnection(strConn);

        // create a connection object to the database
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";


        string username = "";
        if (Request.Cookies["userInfo"] != null)
            username = Request.Cookies["userInfo"].Values["usern"];

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
            lblPref.Visible = true;
            btnCheckIn.Visible = true;
            ddlSeatType.Visible = true;
            lblMsg.Text = "";

            //................................................................................

        }
        else
        {
            lblMsg.Text = "No Booking in such period!!";
            btnCheckIn.Visible = false;
            gdvBooking.Visible = false;
        }
        conn.Close();


    }

    protected void btnDisplaySeats_Click(object sender, EventArgs e)
    {


        if (gdvBooking.SelectedIndex != -1)
        {

            // create a connection object to the database
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";


            lblMsg.Text = "";

            // getting Flight key


            string FlightNo = gdvBooking.SelectedRow.Cells[2].Text;
            string FlightDate = gdvBooking.SelectedRow.Cells[3].Text;


            btnCheckIn.Visible = true;
            gdvSeats.Visible = true;

            string username = "";
            string email = "";
            if (Request.Cookies["userInfo"] != null)
            {
                username = Request.Cookies["userInfo"].Values["usern"];
                email = Request.Cookies["userInfo"].Values["email"];
            }


            string strSelect = "";
            if (ddlSeatType.SelectedValue != "")

                strSelect = "SELECT SeatType, SeatNo FROM FlightSeats "
                + " WHERE FlightNo   = '" + FlightNo + "'"
                + " AND   FlightDate = '" + FlightDate + "'"
                + " AND   SeatType = '" + ddlSeatType.SelectedValue + "'"
                 + " AND   PassengerName is null";

            else

                strSelect = "SELECT SeatType, SeatNo FROM FlightSeats "
            + " WHERE FlightNo   = '" + FlightNo + "'"
            + " AND   FlightDate = '" + FlightDate + "'"
            + " AND   PassengerName is null";


            SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

            DataTable dL = new DataTable();
            conn.Open();
            dL.Load(cmdSelect.ExecuteReader());
            gdvSeats.DataSource = dL;
            gdvSeats.DataBind();
            conn.Close();

        }
        else
            lblMsg.Text = "No Booking Selected!! Select a Booking, then Click the Button Cancel!!";

    }




    protected void btnCheckIn_Click(object sender, EventArgs e)
    {

        lblMsg.Visible = true;
        lblMsg.Text = "Ok!!";

        // string strConn = ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
        // SqlConnection conn = new SqlConnection(strConn);

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

        // get seat number
        string SeatNo = "";
        string SeatType = "";
        SeatNo = gdvSeats.SelectedRow.Cells[2].Text;
        SeatType = gdvSeats.SelectedRow.Cells[1].Text;

        string PassengerName = "";
        string FlightNo = "";
        string FlightDate = "";

        FlightNo = gdvBooking.SelectedRow.Cells[2].Text;
        FlightDate = gdvBooking.SelectedRow.Cells[3].Text;
        PassengerName = gdvBooking.SelectedRow.Cells[8].Text;

        string strUpdate = "UPDATE Booking "
            + " SET SeatNo = '" + SeatNo + "'"
            + " WHERE FlightNo    = '" + FlightNo + "'"
            + " AND FlightDate    = '" + FlightDate + "'"
            + " AND PassengerName = '" + PassengerName + "'";

        SqlCommand cmdUpdate = new SqlCommand(strUpdate, conn);

        conn.Open();
        cmdUpdate.ExecuteNonQuery();
        conn.Close();

        // update booking grid

        string strSelectBB = "SELECT B.RefNo, B.FlightNo, B.FlightDate, F.Dairport, F.Dtime, F.Aairport, F.Atime, B.PassengerName, B.SeatNo "
            + " FROM Booking B, Flight F "
            + " WHERE B.FlightNo   = F.FlightNo "
            + " AND   B.FlightDate = F.FlightDate "
            + " AND   B.Username = '" + username + "'"
            + " AND   B.FlightDate >= '" + txtStartDate.Text + "'"
            + " AND   B.FlightDate <= '" + txtEndDate.Text + "'";


        SqlCommand cmdSelectBB = new SqlCommand(strSelectBB, conn);
        DataTable tblB = new DataTable();
        conn.Open();
        tblB.Load(cmdSelectBB.ExecuteReader());
        conn.Close();

        gdvBooking.DataSource = tblB;
        gdvBooking.DataBind();

        // Update Flight Seats

        string strUpdate2 = "UPDATE FlightSeats "
           + " SET PassengerName = '" + PassengerName + "'"
           + " WHERE FlightNo    = '" + FlightNo + "'"
           + " AND FlightDate    = '" + FlightDate + "'"
           + " AND SeatNo       = '" + SeatNo + "'";

        SqlCommand cmdUpdate2 = new SqlCommand(strUpdate2, conn);

        conn.Open();
        cmdUpdate2.ExecuteNonQuery();
        conn.Close();

        //.......................................................
        // Update seats


        btnCheckIn.Visible = true;
        gdvSeats.Visible = true;


        string strSelect = "";
        if (ddlSeatType.SelectedValue != "")

            strSelect = "SELECT SeatType, SeatNo FROM FlightSeats "
            + " WHERE FlightNo   = '" + FlightNo + "'"
            + " AND   FlightDate = '" + FlightDate + "'"
            + " AND   SeatType = '" + ddlSeatType.SelectedValue + "'"
             + " AND   PassengerName is null";

        else

            strSelect = "SELECT SeatType, SeatNo FROM FlightSeats "
        + " WHERE FlightNo   = '" + FlightNo + "'"
        + " AND   FlightDate = '" + FlightDate + "'"
        + " AND   PassengerName is null";


        SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

        DataTable dL = new DataTable();
        conn.Open();
        dL.Load(cmdSelect.ExecuteReader());
        gdvSeats.DataSource = dL;
        gdvSeats.DataBind();
        conn.Close();


        //..................................................................
    
        string strMsg = "Thanks for booking on the Flight " + FlightNo + " on " +  FlightDate + ", your boarding is on seat " + SeatNo + ", wishing you very enjoyable flight!!";
        lblMsg.Text = strMsg;

        sendEmail(email, strMsg);


    }



    protected void sendEmail(string strEmail, string strMsg)
    {

        MailMessage msg = new MailMessage("CSCE4502@gmail.com", strEmail);
        msg.Subject = "Check In Confirmation";
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
    }
        .style16
        {
            width: 370px;
        }
        .style30
        {
            width: 100%;
        }
        .style31
        {
            width: 283px;
        }
        .style32
        {
            width: 245px;
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
        <td>
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
    <table class="style7">
        <tr>
            <td class="style16">
                <br />
&nbsp;&nbsp;&nbsp;
                </td>
            <td>
                <br />
&nbsp;
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
    
    <br />
     
                    <asp:GridView ID="gdvBooking" runat="server" CellPadding="4" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" GridLines="None">
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        <Columns>
                            <asp:CommandField HeaderText="Select" ShowHeader="True" ShowSelectButton="True" />
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
                    <table class="style30">
                        <tr>
                            <td class="style31">
                                <br />
                                <asp:Label ID="lblPref" runat="server" Font-Names="Arial Black" 
                                    Font-Size="Medium" ForeColor="#000066" Text="Enter Your Prefrence:" 
                                    Visible="False"></asp:Label>
                                &nbsp;<asp:DropDownList ID="ddlSeatType" runat="server" AutoPostBack="True" 
                                    Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" Visible="False">
                                    <asp:ListItem Selected="True"></asp:ListItem>
                                    <asp:ListItem>Aisle</asp:ListItem>
                                    <asp:ListItem>Window</asp:ListItem>
                                    <asp:ListItem>Middle</asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <br />
                            </td>
                            <td class="style32">
                                <asp:Button ID="btnDisplaySeats" runat="server" Font-Names="Arial Black" 
                                    Font-Size="Medium" ForeColor="#000066" onclick="btnDisplaySeats_Click" 
                                    style="margin-right: 0px" Text="Display Available Seats" Width="236px" />
                            </td>
                            <td>
                                <asp:GridView ID="gdvSeats" runat="server" CellPadding="4" Font-Names="Arial" 
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
                            </td>
                        </tr>
                    </table>
                    <br />
            <br />
              
    <br />
            <asp:Button ID="btnCheckIn" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" ForeColor="#000066" onclick="btnCheckIn_Click" 
                Text="Check In" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
    <br />
    
    <br />
    </asp:Content>

