<?php

include "config.php";

 
 if (isset($_POST['Show_ID'])){

    $show_id = $_POST['Show_ID'];
    $is_sequal = $_POST['Is_sequal'];

    $sql_statement = "INSERT INTO Films(Is_sequal,Shows_ID) 
                        VALUES ('$is_sequal', '$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>