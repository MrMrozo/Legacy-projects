<?php
    session_start();
    if(isset($_GET["wyloguj"])){
        $_SESSION = array();
        session_destroy();
    }
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <form action="blog.php" method="POST">
            <p>Podaj login <input type="text" name="user"></p>
            <p>Podaj hasło <input type="password" name="pass"></p>
            <p><input type="submit" value="Who is Julius?" name="sub"></p>
        </form>
        <?php
            if(isset($_GET["wyloguj"])){
                echo "Poprawnie wylogowano";
            }
        ?>
    </body>
</html>
