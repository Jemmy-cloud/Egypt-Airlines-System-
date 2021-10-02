<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.master" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            string username = "";
            if (Request.Cookies["userInfo"] != null)
                username = Request.Cookies["userInfo"].Values["usern"];

            ViewState["U"] = username;

            imgUserPic.ImageUrl = "~/userPic/" + username + ".jpg";

            // 1- Create Connection Object
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";


            // Create SQL Select Query
            string strSelect = "SELECT * FROM Member "
                + " WHERE Username = '" + username + "'";

            SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

            SqlDataReader reader;

            conn.Open();
            reader = cmdSelect.ExecuteReader();

            if (reader.Read())
            {
                txtFname.Text = (string)reader.GetValue(0);
                txtLname.Text = (string)reader.GetValue(1);
                rblSex.SelectedValue = (string)reader.GetValue(2);
                txtEmail.Text = (string)reader.GetValue(3);
                txtPhone.Text = (string)reader.GetValue(4);
                ddlCountry.SelectedValue = (string)reader.GetValue(5);
                txtUsername.Text = (string)reader.GetValue(6);

                imgUserPic.ImageUrl = "~/userPic/" + username + ".jpg";
            }

        }

    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        txtFname.Enabled = true;
        txtLname.Enabled = true;
        rblSex.Enabled = true;
        txtEmail.Enabled = true;
        txtPhone.Enabled = true;
        ddlCountry.Enabled = true;
        fupPic.Enabled = true;

        btnSave.Visible = true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";


        string username = "";
        username = (string)ViewState["U"];

        string strUpdate = "Update Member "
            + " SET Fname = '" + txtFname.Text + "', "
            + " Lname = '" + txtLname.Text + "', "
            + " Sex = '" + rblSex.SelectedValue + "', "
            + " Email = '" + txtEmail.Text + "', "
            + " Phone = '" + txtPhone.Text + "', "
            + " Country = '" + ddlCountry.SelectedValue + "' "
            + " WHERE Username = '" + username  + "'";

        SqlCommand cmdUpdate = new SqlCommand(strUpdate, conn);

        conn.Open();
        cmdUpdate.ExecuteNonQuery();

        if (fupPic.HasFile)
            fupPic.SaveAs(Server.MapPath("userPic") + "\\" + username + ".jpg");

        conn.Close();

        lblMsg.Text = "Your Account Has Been Successfully Updated!!";


    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style13
        {
            width: 122px;
        }
        .style14
        {
            width: 196px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>
        <br />
        <asp:Label ID="Label1" runat="server" Font-Names="Arial Black" 
            Font-Size="Medium" ForeColor="#000066" Text="Your Account:"></asp:Label>
    </p>
    <table class="style7">
        <tr>
            <td class="style13">
                <asp:Label ID="Label2" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="First Name:"></asp:Label>
            </td>
            <td class="style14">
                <asp:TextBox ID="txtFname" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Width="175px" Enabled="False"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label3" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Last Name:"></asp:Label>
            </td>
            <td class="style14">
                <asp:TextBox ID="txtLname" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Width="175px" Enabled="False"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label4" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Sex:"></asp:Label>
            </td>
            <td class="style14">
                <asp:RadioButtonList ID="rblSex" runat="server" Font-Names="Arial" 
                    Font-Size="Medium" ForeColor="#000066" RepeatDirection="Horizontal" 
                    Enabled="False">
                    <asp:ListItem Value="M">Male</asp:ListItem>
                    <asp:ListItem Value="F">Female</asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label5" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Email Address:"></asp:Label>
            </td>
            <td class="style14">
                <asp:TextBox ID="txtEmail" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Width="175px" Enabled="False"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label6" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Phone Number:"></asp:Label>
            </td>
            <td class="style14">
                <asp:TextBox ID="txtPhone" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Width="175px" Enabled="False"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label7" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Country:"></asp:Label>
            </td>
            <td class="style14">
                <asp:DropDownList ID="ddlCountry" runat="server" Font-Names="Arial" 
                    ForeColor="#000066" Enabled="False" DataSourceID="SqlDataSource1" DataTextField="Country" DataValueField="Country">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT [Country] FROM [Member] ORDER BY [Country]"></asp:SqlDataSource>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label8" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Username:"></asp:Label>
            </td>
            <td class="style14">
                <asp:TextBox ID="txtUsername" runat="server" Font-Names="Arial" 
                    Font-Size="Medium" ForeColor="#000066" Width="175px" Enabled="False"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Label ID="Label9" runat="server" Font-Names="Arial" Font-Size="Medium" 
                    ForeColor="#000066" Text="Your Picture:"></asp:Label>
            </td>
            <td class="style14">
                <asp:FileUpload ID="fupPic" runat="server" Enabled="False" />
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                &nbsp;</td>
            <td class="style14">
                &nbsp;</td>
            <td rowspan="5">
                <asp:Image ID="imgUserPic" runat="server" Height="100px" Width="100px" />
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                &nbsp;</td>
            <td class="style14">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                </td>
            <td class="style14">
                </td>
            <td>
                </td>
        </tr>
        <tr>
            <td class="style13">
                &nbsp;</td>
            <td class="style14">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style13">
                </td>
            <td class="style14">
                </td>
            <td>
                </td>
        </tr>
        <tr>
            <td class="style13">
                <asp:Button ID="btnEdit" runat="server" Font-Names="Arial Black" 
                    Font-Size="Medium" ForeColor="#000066" Text="Edit" 
                    onclick="btnEdit_Click"  />
            </td>
            <td class="style14">
                <asp:Button ID="btnSave" runat="server" Font-Names="Arial Black" 
                    Font-Size="Medium" onclick="btnSave_Click" Text="Save" Visible="False" />
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
    <p>
        <asp:Label ID="lblMsg" runat="server" Font-Names="Monotype Corsiva" 
            Font-Size="X-Large" ForeColor="#CC6600"></asp:Label>
    </p>
</asp:Content>

