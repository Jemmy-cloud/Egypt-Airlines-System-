<%@ Page Title="" Language="C#" MasterPageFile="~/adminMaster.master" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.BindData();
        }
    }

    private void BindData()
    {
                
      //  string strConnString = "Data Source=.\\SQLEXPRESS;AttachDbFilename=|DataDirectory|Egypt.mdf;Integrated Security=True;User Instance=True";

        string strConnString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
        
        DataTable dt = new DataTable();
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            string strQuery = "SELECT * FROM Flight";
            SqlCommand cmd = new SqlCommand(strQuery);
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                con.Open();
                sda.SelectCommand = cmd;
                sda.Fill(dt);
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
    }


    protected void Add(object sender, EventArgs e)
    {
        Control control = null;
        if (GridView1.FooterRow != null)
        {
            control = GridView1.FooterRow;
        }
        else
        {
            control = GridView1.Controls[0].Controls[0];
        }
        string FlightNo = (control.FindControl("txtFlightNo") as TextBox).Text;
        string FlightDate = (control.FindControl("txtFlightDate") as TextBox).Text;
        string Dairport = (control.FindControl("ddlDairport") as DropDownList).SelectedValue;
        string Dtime = (control.FindControl("txtDtime") as TextBox).Text;
        string Aairport = (control.FindControl("ddlAairport") as DropDownList).SelectedValue;
        string Atime = (control.FindControl("txtAtime") as TextBox).Text;
        string Seats = (control.FindControl("txtSeats") as TextBox).Text;
        
        
        
        // string strConnString = ConfigurationManager.ConnectionStrings["conString"].ConnectionString;

        string strConnString = "Data Source=.\\SQLEXPRESS;AttachDbFilename=|DataDirectory|Egypt.mdf;Integrated Security=True;User Instance=True";
        
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "INSERT INTO [Flight] VALUES(@FlightNo, @FlightDate, @Dairport, @Dtime,  @Aairport, @Atime, @seats)";
                cmd.Parameters.AddWithValue("@FlightNo", FlightNo);
                cmd.Parameters.AddWithValue("@FlightDate", FlightDate);
                cmd.Parameters.AddWithValue("@Dairport", Dairport);
                cmd.Parameters.AddWithValue("@Dtime", Dtime);
                cmd.Parameters.AddWithValue("@Aairport", Aairport);
                cmd.Parameters.AddWithValue("@Atime", Atime);
                cmd.Parameters.AddWithValue("@seats", Seats);
                
                
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }
        Response.Redirect(Request.Url.AbsoluteUri);
    }


   
    
    
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<asp:GridView ID="GridView1" runat="server" Width="50px" AutoGenerateColumns="False"
    AlternatingRowStyle-BackColor="#C2D69B" HeaderStyle-BackColor="yellow" 
        ShowFooter="True" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#333333" CellPadding="2" GridLines="None" PageSize="5" 
        AllowSorting="True">
    <Columns>
        <asp:TemplateField HeaderText="FlightNo">
            <ItemTemplate>
                <%# Eval("FlightNo") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtFlightNo" runat="server" />
            </FooterTemplate>
            <ControlStyle Width="50px" />
            <HeaderStyle HorizontalAlign="Left" Width="50px" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Flight Date">
            <ItemTemplate>
                <%# Eval("FlightDate") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtFlightDate" runat="server" />
            </FooterTemplate>
            <HeaderStyle HorizontalAlign="Left" />
            <ItemStyle Wrap="False" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Departure Airport">
            <ItemTemplate>
                <%# Eval("Dairport") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:DropDownList ID="ddlDairport" runat="server">
                
                    <asp:ListItem>Cairo</asp:ListItem>
                    <asp:ListItem>Alexandria</asp:ListItem>
                    <asp:ListItem>Aswan</asp:ListItem>
                    <asp:ListItem>Hurgada</asp:ListItem>
                    <asp:ListItem>Sharm El Sheikh</asp:ListItem>
                
                </asp:DropDownList>
            </FooterTemplate>
            <HeaderStyle HorizontalAlign="Left" />
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Departure Time">
            <ItemTemplate>
                <%# Eval("Dtime") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtDtime" runat="server"></asp:TextBox>
            </FooterTemplate>
            <ControlStyle Width="100px" />
            <HeaderStyle HorizontalAlign="Left" />
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Arrival Airport">
            <ItemTemplate>
                <%# Eval("Aairport") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:DropDownList ID="ddlAairport" runat="server">
                
                    <asp:ListItem>Paris</asp:ListItem>
                    <asp:ListItem>London</asp:ListItem>
                    <asp:ListItem>Rome</asp:ListItem>
                    <asp:ListItem>New York</asp:ListItem>
                    <asp:ListItem>Madrid</asp:ListItem>
                
                </asp:DropDownList>
            </FooterTemplate>
            <HeaderStyle HorizontalAlign="Left" />
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Arrival Time">
            <ItemTemplate>
                <%# Eval("Atime") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtAtime" runat="server"></asp:TextBox>
            </FooterTemplate>
            <HeaderStyle HorizontalAlign="Left" />
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Seats">
            <ItemTemplate>
                <%# Eval("Seats") %>
            </ItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtSeats" runat="server"></asp:TextBox>
            </FooterTemplate>
            <HeaderStyle HorizontalAlign="Center" Width="100px" />
        </asp:TemplateField>

            <asp:TemplateField>
            <ItemTemplate>
            </ItemTemplate>
            <FooterTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="Add" CommandName = "Footer" />
            </FooterTemplate>
                <ControlStyle Width="100px" />
        </asp:TemplateField>
    </Columns>
    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    <EditRowStyle BackColor="#999999" />
    <EmptyDataTemplate>
        <tr style="background-color: Yellow;">
            <th scope="col" >
                Flight No
            </th>
            <th scope="col">
                Flight Date
            </th>
            <th scope="col">
                Departure Airport
            </th>

            <th scope="col">
                Departure Time
            </th>

            <th scope="col">
                Arrival Airport
            </th>

            <th scope="col">
                Arrival Time
            </th>

            <th scope="col">
                 Seats  
            </th>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="txtFlightNo" runat="server" />
            </td>
            <td>
                <asp:TextBox ID="txtFlightDate" runat="server" />
            </td>
            <td>
                <asp:DropDownList ID="ddlDairport" runat="server" />
                    
            </td>

            <td>
                <asp:TextBox ID="txtDtime" runat="server" />
            </td>

            <td>
                <asp:DropDownList ID="ddlAairport" runat="server" />
            </td>

            <td>
                <asp:TextBox ID="Atime" runat="server" />
            </td>

            <td>
                <asp:TextBox ID="TextSeats" runat="server" />
            </td>

            <td>
                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="Add" CommandName = "EmptyDataTemplate" />
            </td>
        </tr>
    </EmptyDataTemplate>

    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />

<HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"></HeaderStyle>
    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
    <SortedAscendingCellStyle BackColor="#E9E7E2" />
    <SortedAscendingHeaderStyle BackColor="#506C8C" />
    <SortedDescendingCellStyle BackColor="#FFFDF8" />
    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
</asp:GridView>
 



</asp:Content>

