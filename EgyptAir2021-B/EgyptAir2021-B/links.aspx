<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 80%;
        }
        .auto-style2 {
            width: 147px;
        }
        .auto-style3 {
            width: 162px;
        }
        .auto-style4 {
            width: 132px;
        }
        .auto-style5 {
            width: 144px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table class="auto-style1">
                <tr>
                    <td class="auto-style2">
                        <asp:HyperLink ID="HyperLink1" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" NavigateUrl="~/main.htm" Target="F5">Egypt</asp:HyperLink>
                    </td>
                    <td class="auto-style3">
                        <asp:HyperLink ID="HyperLink2" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" NavigateUrl="http://www.fue.edu.eg" Target="_top">FUE</asp:HyperLink>
                    </td>
                    <td class="auto-style4">
                        <asp:HyperLink ID="HyperLink3" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" NavigateUrl="http://EgyptAir.com" Target="F5">EgyptAir</asp:HyperLink>
                    </td>
                    <td class="auto-style5">
                        <asp:HyperLink ID="HyperLink4" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" NavigateUrl="~/signup.aspx" Target="F5">Sign Up</asp:HyperLink>
                    </td>
                    <td>
                        <asp:HyperLink ID="HyperLink5" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" NavigateUrl="~/signin.aspx" Target="_top">Sign In</asp:HyperLink>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
