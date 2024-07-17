<?php

include "config.php";

 
 if (isset($_POST['show_name'])){

    $show_name = $_POST['show_name'];
    $box_office_gross = $_POST['box_office_gross'];
    $IMDB_rating = $_POST['IMDB_rating'];

    echo $show_id . " " . $show_name . " " . $box_office_gross . " " . $IMDB_rating . "<br>";

    $sql_statement = "INSERT INTO shows(Shows_Name,Box_Office_Gross,IMDB_Rating) 
                        VALUES ('$show_name', '$box_office_gross', '$IMDB_rating')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>