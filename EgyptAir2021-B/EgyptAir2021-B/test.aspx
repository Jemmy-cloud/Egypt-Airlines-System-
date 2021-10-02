<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.master" %>

<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {
        imgU.ImageUrl = "~/userPic/" + "akhalil21" + ".jpg";
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>
        <br />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" />
    </p>
    <p>
    </p>
    <p>
        <asp:Image ID="imgU" runat="server" ImageUrl="~/userPic/nathalieK.jpg" Width="100px" />
    </p>
    <p>
    </p>
</asp:Content>

