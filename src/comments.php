<?
  $db = new SQLite3("gtfo.db");
  $stmt = $db->prepare('insert into "comments"
    ("slug", "name", "url", "email", "payload") values
    (:slug, :name, :url, :email, :payload)');

  if($_POST['orange'] != 'orange')
    die("orange must be orange");

  $required = array("name", "payload");
  foreach($required as $req) {
    if(isset($_POST[$req]))
      $stmt->bindValue(":" . $req, $_POST[$req]);
    else
      die($req . " is required!");
  }

  $optional = array("url", "email");
  foreach($optional as $opt) {
    if(isset($_POST[$opt]))
      $stmt->bindValue(":" . $opt, $_POST[$opt]);
    else
      $stmt->bindValue(":" . $opt, null, SQLITE3_NULL);
  }

  $referrer = preg_replace('/http:\/\/.*?tycho.ws\//', '', $_SERVER["HTTP_REFERER"]);
  $pi = pathinfo($referrer);
  $slug = trim($pi['dirname'], '/') . "/" . $pi["filename"];
  $stmt->bindValue(":slug", $slug);

  $stmt->execute();
  $stmt->close();
  $db->close();
?>
