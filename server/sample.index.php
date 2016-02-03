<?php
$user = $_POST['user'];
$pass = $_POST['pass'];

if($user == "[USER]"
&& $pass == "[PASSWD]")
{
        $con=mysqli_connect("localhost","[BD_USER]","[BD_PASSWD]","[BD_NAME]");
        // Check connection
        if (mysqli_connect_errno())
        {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
        }

        $result = mysqli_query($con,"SELECT * FROM RemoteDevices");

        echo "<table border='1'>
        <tr>
        <th>IdDevice</th>
        <th>URL</th>
        <th>LastSeen</th>
        </tr>";

        while($row = mysqli_fetch_array($result))
        {
        echo "<tr>";
        echo "<td>" . $row['idDevice'] . "</td>";
        echo "<td>" . $row['URL'] . "</td>";
        echo "<td>" . $row['LastSeen'] . "</td>";
        echo "</tr>";
        }
        echo "</table>";

        mysqli_close($con);
}
else
{
    if(isset($_POST))
    {?>

            <form method="POST" action="index.php">
            User <input type="text" name="user"></input><br/>
            Pass <input type="password" name="pass"></input><br/>
            <input type="submit" name="submit" value="Go"></input>
            </form>
    <?}
}

