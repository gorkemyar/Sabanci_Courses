
<html>
    <head>
        <title>SELECTION</title>
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





<?php
include "config.php";

if (isset($_POST['foo'])){

$selection_id = $_POST['foo'];
    if ($selection_id=="IMDB rating 8+ movies"){
        ?>
        <tr><th>Show Name</th></tr>
        <?php
        $sql_statement = "SELECT * FROM Shows WHERE IMDB_Rating>8.0";
        $result = mysqli_query($db,$sql_statement);
        while ($row = mysqli_fetch_assoc($result)) 
        {

            $show_name = $row['Shows_Name'];           
            echo "<tr>" . "<th>" . $show_name . "</th>"."</tr>";
        }

    }
    if ($selection_id=="Duration 120+ movies"){
        ?>
        <tr><th>Show Name</th></tr>
        <?php
        $sql_statement = "SELECT * FROM Shows, Duration WHERE Duration_time>120 and Duration.Shows_ID=Shows.Shows_ID";
        $result = mysqli_query($db,$sql_statement);
        while ($row = mysqli_fetch_assoc($result)) 
        {
            $show_name = $row['Shows_Name'];           
            echo "<tr>" . "<th>" . $show_name . "</th>"."</tr>";
        }

    }
    if ($selection_id=="Drama Shows"){
        ?>
        <tr><th>Show Name</th></tr>
        <?php
        $sql_statement = "SELECT * FROM Genre, Shows, Has WHERE Shows.Shows_ID=Has.Shows_ID and Has.Genre_ID=Genre.Genre_ID and Genre_Name='Drama'";

        $result = mysqli_query($db,$sql_statement);
        while ($row = mysqli_fetch_assoc($result)) 
        {
            $show_name = $row['Shows_Name'];           
            echo "<tr>" . "<th>" . $show_name . "</th>"."</tr>";
        }
    }
    

}
else{
    echo "The form is not set";
}
?>

</table>
</div>
    </body>
</html>