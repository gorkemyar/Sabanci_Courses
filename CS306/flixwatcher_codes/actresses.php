
<html>
    <head>
        <title>Database</title>
        <style>
table {
  border-collapse: collapse;
    margin: 25px 0;
    width: 100%;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
}
thead tr {
    background-color: #e76f51;
    color: #ffffff;
    text-align: left;
    border-bottom: 2px solid #264653;
}

td, th {
  border: 2px solid #264653;
  text-align: left;
  padding: 8px;
}

tbody tr:nth-child(even) {
  background-color: #264653;
}

tbody tr:nth-child(odd) {
  background-color: #2a9d8f;
}

tbody tr:hover {
    font-weight: bold;
    background-color: #e9c46a;
}
</style>
    </head>
    <body>
        <div allign="center">
    <table>
      <thead>
<tr><th>Actress_ID</th><th>Actress_Name</th></tr>
</thead>
<tbody>

<?php
include "config.php";

$sql_statement = "SELECT * FROM actresses";

$result = mysqli_query($db,$sql_statement);
while ($row = mysqli_fetch_assoc($result)) 
{
    $actress_id = $row['Actress_ID'];
    $actress_name = $row['Actress_Name'];
   
    echo "<tr>" . "<th>" . $actress_id . "</th>". "<th>" . $actress_name . "</th>"."</tr>";
}

?>
</tbody>
</table>
</div>
    </body>
</html>