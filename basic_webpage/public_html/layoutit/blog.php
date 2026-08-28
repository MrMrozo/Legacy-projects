<?php
    if(isset($_POST["user"])){
        if($_POST["user"] == "jan" && md5($_POST["pass"]) == "77f869401de682f60e0e749493ab793d"){
            session_start();
        $_SESSION["zl"] = 1;
        }
    }
    elseif(isset($_POST["sub"])){
        session_start();
        $_SESSION["zl"] = 1;
        setcookie("ciacho", 1, time()+20);
    }
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>layoutit-project</title>
    <meta name="description" content="Generated with Layoutit" />
    <link rel="stylesheet" href="./bootstrap.min.css" />
    <link href="style1.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    <div class="container">
    <div class="row">
        <div class="col-8">
            <h3 class="h3">
                h3. Lorem ipsum dolor sit amet.
            </h3>
            <p>
                Lorem ipsum dolor sit amet,
                consectetur adipiscing elit.
                Aliquam eget sapien sapien.
                Curabitur in metus urna. In hac
                habitasse platea dictumst.
                Phasellus eu sem sapien, sed
                vestibulum velit. Nam purus nibh,
                lacinia non faucibus et, pharetra
                in dolor. Sed iaculis posuere diam
                ut cursus. Morbi commodo sodales
                nisi id sodales. Proin
                consectetur, nisi id commodo
                imperdiet, metus nunc consequat
                lectus, id bibendum diam velit et
                dui. Proin massa magna, vulputate
                nec bibendum nec, posuere nec
                lacus. Aliquam mi erat, aliquam
                vel luctus eu, pharetra quis elit.
                Nulla euismod ultrices massa, et
                feugiat ipsum consequat eu.
            </p>
            <h3 class="h3">
                h3. Lorem ipsum dolor sit amet.
            </h3>
            <p>
                Lorem ipsum dolor sit amet,
                consectetur adipiscing elit.
                Aliquam eget sapien sapien.
                Curabitur in metus urna. In hac
                habitasse platea dictumst.
                Phasellus eu sem sapien, sed
                vestibulum velit. Nam purus nibh,
                lacinia non faucibus et, pharetra
                in dolor. Sed iaculis posuere diam
                ut cursus. Morbi commodo sodales
                nisi id sodales. Proin
                consectetur, nisi id commodo
                imperdiet, metus nunc consequat
                lectus, id bibendum diam velit et
                dui. Proin massa magna, vulputate
                nec bibendum nec, posuere nec
                lacus. Aliquam mi erat, aliquam
                vel luctus eu, pharetra quis elit.
                Nulla euismod ultrices massa, et
                feugiat ipsum consequat eu.
            </p>
            <?php
                if(isset($_SESSION["zl"])){
                    echo '<form action="blog.php" method="POST">
                        <p><textarea name="kom"></textarea></p>
                        <p><input type="submit" value="happy birthday Daniel!" name="sub"></p>
                        </form>';
                    echo '<a href=index.php?wyloguj>Wyloguj sie</a>';
                    if(isset($_POST["kom"]) && !isset($_COOKIE["ciacho"])){
                        $f = fopen("newsy.txt", "a");
                        fwrite($f, time() . "\n" . urlencode($_POST["kom"]) . "\n");
                        fclose($f);
                    }
                }
                $tabf = file("newsy.txt");
                $ile = count($tabf);
                for($i=$ile-1; $i>=0; $i-=2){
                    echo '<fieldset class="kom"><legend>' .
                         date("Y-m-d H:i:s",$tabf[$i-1]) .
                         '</legend>' .
                         urldecode($tabf[$i]) .
                         '</fieldset>';
                }
                
                
                /*
                $f = fopen("newsy.txt", "r");
                while ($linia=fgets($f)){
                    echo '<div class="kom">' .
                        urldecode($linia) .
                        '</div>';
                }*/
                
            ?>
            <div class="kom">
                <p>No Konto?</p>
                <img src="megamind.png" alt="" width="250" height="400"/>
            </div>
        </div>
        <div class="col-4">
            <img
                class="img-fluid"
                src="cat_ok.png"
                alt="Bike"
            />
            <address>
                <strong>Acme Corp.</strong>
                <br />
                <span>
                    1234 Market St, Suite 900
                </span>
                <br />
                <span>
                    San Francisco, CA 94103
                </span>
                <br />
                <abbr title="Phone">P:</abbr>
                <span> (123) 456-7890</span>
            </address>
        </div>
    </div>
</div>
    <script src="./bootstrap.bundle.min.js"></script>
  </body>
</html>
