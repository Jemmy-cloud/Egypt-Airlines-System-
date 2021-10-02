<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.master" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
       

        lblMg.Text = "Welcome to User Home Page!!";

    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="lblMg" runat="server" Font-Names="Arial Black" Font-Size="XX-Large"></asp:Label>
</asp:Content>

