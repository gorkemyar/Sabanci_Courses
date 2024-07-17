<?php 

include "config.php";

if (isset($_POST['foo'])){

$selection_id = $_POST['foo'];
?>

<style type="text/css">
    body {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background: #eceffc;
    }
    .form {
        background-color: #264653;
        border-radius: 20px;
        box-sizing: border-box;
        height: 400px auto;
        padding: 20px;
        width: 320px;
        position: absolute;
        top: 80;
    }
    input[type=text], input[type=integer]{
        -webkit-transition: all 0.30s ease-in-out;
        -moz-transition: all 0.30s ease-in-out;
        -ms-transition: all 0.30s ease-in-out;
        -o-transition: all 0.30s ease-in-out;
        outline: none;
        box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        border-radius: 5px;
        width: 100%;
        background: #fff;
        margin-bottom: 5%;
        border: 1px solid #ccc;
        padding: 3%;
        color: #555;
        font: 95% Arial, Helvetica, sans-serif;
        margin-top: 10px;

    }
    input[type=text]:focus, input[type=integer]:focus {
        box-shadow: 0 0 5px #43D1AF;
        padding: 3%;
        border: 1px solid #43D1AF;
    }

    button{
        box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        width: 100%;
        padding: 3%;
        background: #E9C46A;
        border-top-style: none;
        border-right-style: none;
        border-left-style: none;	
        color: black;;
        border-radius: 5px;
        margin-top: 5px;
        font-weight: bold;
    }
    button:hover, button:focus {
        background-color: #D7D7DC;
        color: black;
    }

</style>

<?php
if ($selection_id=="Shows"){
    include "shows.php";?>
    <br><br><br>
    <?php

?>	
<br><br><br>
    <div class=form>
    <form action="show_insertion.php" method = "POST">
        <input type="text" name="show_name" placeholder="Type show name"> <br>
        <input type="integer" name="box_office_gross" placeholder="Type box office gross"> <br>
        <input type="integer" name="IMDB_rating" placeholder="Type IMDB rating"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Producers"){
    include "producer.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>

    <form action="prod_insertion.php" method = "POST">
        <input type="text" name="Producer_Name" placeholder="Type producer name"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Directors"){
    include "director.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>

    <form action="directors_insertion.php" method = "POST">
        <input type="text" name="Director_Name" placeholder="Type director name"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Actors"){
    include "actor.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>

    <form action="actor_insertion.php" method = "POST">
        <input type="text" name="Actor_Name" placeholder="Type actor name"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Actresses"){
    include "actresses.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>

    <form action="actress_insertion.php" method = "POST">
        <input type="text" name="Actress_Name" placeholder="Type actress name"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Award"){
    include "award.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>
    <form action="award_insertion.php" method = "POST">
        <input type="text" name="Award_Type" placeholder="Type award"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Genre"){
    include "genres.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>
    <form action="genre_insertion.php" method = "POST">
        <input type="text" name="Genre_Name" placeholder="Type genre"> <br>
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Year"){
	include "shows.php"; ?>
    <br><br><br>
    <?php
    include "year.php";?>
    <br><br><br>
    <?php
?>	
<br><br><br>
<div class=form>
    <form action="year_insertion.php" method = "POST">
        <input type="text" name="Releasing_Year" placeholder="Type releasing year">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>


<?php
if ($selection_id=="Netflix_Availability"){
	include "shows.php"?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="availibility_insertion.php" method = "POST">
        <input type="text" name="Start_Date" placeholder="Type starting date">  <br>
        <input type="text" name="End_Date" placeholder="Type ending date">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Restrictions"){
	include "shows.php"?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="restrictions_insertion.php" method = "POST">
        <input type="text" name="Restriction_type" placeholder="Type restriction">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Languages"){
    include "languages.php"
    ?>
    <br><br><br>
    <?php
	include "shows.php"
    ?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="languages_insertion.php" method = "POST">
        <input type="text" name="Subtitle" placeholder="Type subtitle options">  <br>
        <input type="text" name="Voice" placeholder="Type voice options">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Duration"){
	include "shows.php";
    ?>
    <br><br><br>
    <?php
    include "duration.php";?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="duration_insertion.php" method = "POST">
        <input type="text" name="Duration_time" placeholder="Type duration time">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Has"){
	include "genres.php";
    ?>
    <br><br><br>
    <?php
	include "shows.php";
    ?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="Has_insertion.php" method = "POST">
        <input type="text" name="Genre_ID" placeholder="Genre_id">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Gained"){
	include "award.php";
    ?>
    <br><br><br>
    <?php
	include "shows.php";?>
    <br><br><br>
    <?php

?>	
    <div class=form>
    <form action="gained_insertion.php" method = "POST">
        <input type="text" name="Award_Type" placeholder="Award_Type">  <br>
        <input type="text" name="Shows_ID" placeholder="Show_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>
<?php
if ($selection_id=="Sponsors_Actors"){

	include "actor.php";
    ?>
    <br><br><br>
    <?php
	include "producer.php";?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="sponsors_actor_insertion.php" method = "POST">
        <input type="text" name="Actor_ID" placeholder="Type actor_id">  <br>
        <input type="text" name="Producer_ID" placeholder="Type producer_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Sponsors_Actress"){
	include "actresses.php";
    ?>
    <br><br><br>
    <?php
	include "producer.php";?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="Sponsors_actress_insertion.php" method = "POST">
        <input type="text" name="Actress_ID" placeholder="Type actress_id">  <br>
        <input type="text" name="Producer_ID" placeholder="Type producer_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="Sponsors_Director"){
	include "director.php";
    ?>
    <br><br><br>
    <?php
	include "producer.php";?>
    <br><br><br>
    <?php
?>	
    <div class=form>
    <form action="sponsors_director_insertion.php" method = "POST">
        <input type="text" name="Director_ID" placeholder="Type director_id">  <br>
        <input type="text" name="Producer_ID" placeholder="Type producer_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>


<?php
if ($selection_id=="Made_By"){
	include "shows.php";
    ?>
    <br><br><br>
    <?php
	include "producer.php";
?>	
    <div class=form>

    <form action="made_by_insertion.php" method = "POST">
        <input type="text" name="Show_ID" placeholder="_id">  <br>
        <input type="text" name="Producer_ID" placeholder="Type producer_id"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>

<?php
if ($selection_id=="TV_Shows"){
	include "shows.php";?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="tv_shows_insertion.php" method = "POST">
        <input type="text" name="Show_ID" placeholder="show_id">  <br>
        <input type="text" name="Season_num" placeholder="Number of seasons"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>


<?php
if ($selection_id=="Films"){
	include "shows.php";?>
    <br><br><br>
    <?php
?>	
    <div class=form>

    <form action="films_insertion.php" method = "POST">
        <input type="text" name="Show_ID" placeholder="show_id">  <br>
        <input type="text" name="Is_sequal" placeholder="Is it sequal?"> <br>		 
        <button>INSERT</button>
</div>
<?php
}
?>


<?php
}

else
{

	echo "The form is not set.";

}

?>



