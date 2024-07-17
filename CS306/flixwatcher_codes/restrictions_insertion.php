<?php

include "config.php";

 
 if (isset($_POST['Shows_ID'])){

    $restiriction = $_POST['Restriction_type'];
    $show_id = $_POST['Shows_ID'];

    $sql_statement = "INSERT INTO Restrictions(Restriction_Type, Shows_ID) 
                        VALUES ('$restiriction', '$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>