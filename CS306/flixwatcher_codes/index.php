<html>

<head>
    <title> MAIN PAGE</title>
    
</head>
<body>
    <div align = "center">
    <h1>Welcome to Netflix show database</h1>

    <br><br>
    <h2>What do you want to see?</h2>
    <br><br><br>
    <div class=formsmall>
    <form action="selection.php" method="POST">
    <input type="submit" name="foo" value="IMDB rating 8+ movies" />
    <input type="submit" name="foo" value="Duration 120+ movies" />
    <input type="submit" name="foo" value="Drama Shows" />
</div>
    </form>


    <br><br>
    <h2>What do you want to add?</h2>
    <br><br><br>


    <?php

include "config.php";

?>
<style type="text/css">
body {
        display: flex;
        min-height: 100vh;
        background: #eceffc;
        
    }
    .form {
        background-color: #264653;
        border-radius: 20px;
        box-sizing: border-box;
        height: 130px ;
        padding: 10px;
        width: 100%;
        position: relative;
        text-align: center;
        justify-content: center;

    }
    .formsmall {
        background-color: #264653;
        border-radius: 20px;
        box-sizing: border-box;
        height: 80px;
        padding: 10px;
        width: 100%;
        position: relative;
        align-items: center;


    }
    input[type=submit]{
        padding: 10px 26px;
        margin: 10px;
        overflow: hidden;
        position: relative;
        border-width: 0;
        outline: none;
        border-radius: 2px;
        box-shadow: 0 1px 4px rgba(0, 0, 0, .6);
        float: center;
        background-color: #2A9D8F;
        color: #ecf0f1;
        font-family: Georgia, serif;
        transition: background-color .3s;
        border-radius: 5px;
        text-align: center;
        justify-content: center;
        
    }
    input[type=submit]:hover, input[type=submit]:focus {
        background-color: #D7D7DC;
        color: black;
    }
    h3{
        text-align: center;
        font-family: Georgia, serif;
        margin: 10px;
        color: #E76F51;
    }
    h1{
        margin: 10px;
        font-family: Georgia, serif;
        color: #E76F51;
    }
    h2{
        font-family: Georgia, serif;
        margin: 10px;
        color: #E76F51;
    }
    button{
        padding: 1%;
        background: #E9C46A;
        border-top-style: none;
        border-right-style: none;
        border-left-style: none;
        border-bottom-style: none;	
        color: #fff;
        border-radius: 5px;
        margin-top: 5px;
        box-shadow: 0 1px 4px rgba(0, 0, 0, .6);
    }
    button:hover{
        background-color: red;
    }
    select {
        width: 35%;
        padding: 16px 20px;
        border: none;
        border-radius: 4px;
        background-color: #f4a261;
    }
</style>
<div class=form>
<form action="sendadmin.php" method="POST">
<input type="submit" name="foo" value="Shows" />
<input type="submit" name="foo" value="Producers" />
<input type="submit" name="foo" value="Directors" />
<input type="submit" name="foo" value="Actors" />
<input type="submit" name="foo" value="Actresses" />
<input type="submit" name="foo" value="Award" />
<input type="submit" name="foo" value="Genre" />
<input type="submit" name="foo" value="Year" />
<input type="submit" name="foo" value="Netflix_Availability" />
<input type="submit" name="foo" value="Duration" />
<input type="submit" name="foo" value="Restrictions" />
<input type="submit" name="foo" value="Languages" />
<input type="submit" name="foo" value="Gained" />
<input type="submit" name="foo" value="Has" />
<input type="submit" name="foo" value="Sponsors_Actors" />
<input type="submit" name="foo" value="Sponsors_Actress" />
<input type="submit" name="foo" value="Sponsors_Director" />
<input type="submit" name="foo" value="Made_By" />
<input type="submit" name="foo" value="TV_Shows" />
<input type="submit" name="foo" value="Films" />
</div>
</form>

    <br><br>
    <h2>What do you want to delete?</h2>
    <br><br>
    <?php
    include "shows.php"
    ?>
    <br><br>
    <form action="senddeleteadmin.php" method = "POST">
    <select name="ids">


    <?php
    $sql_command = "SELECT Shows_ID FROM shows";
    $myresult = mysqli_query($db, $sql_command);

    while($id_rows = mysqli_fetch_assoc($myresult)){
    $id = $id_rows['Shows_ID'];
    echo "<option value=$id>". $id ." </option>";
    }
    ?>
    </select>
    <button>DELETE with Show_ID</button>
    </form>
    </div>
</body>


</html>
