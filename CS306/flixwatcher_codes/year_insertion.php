<?php

include "config.php";

 
 if (isset($_POST['Shows_ID'])){

    $year = $_POST['Releasing_Year'];
    $show_id = $_POST['Shows_ID'];

    $sql_statement = "INSERT INTO Year_Made_in( Releasing_Year,Shows_ID) 
                        VALUES ('$year' ,'$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>