# Simple PHP 7 DB Connection Test to Database Using PDO (OOP)

```php
// Open connection
try 
{
	
	$host = '127.0.0.1';
	$db   = 'test';
	$user = 'test';
	$pass = 'tRWrik4g54ldVWjT';
	$charset = 'utf8mb4';

	$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
	$opt = [
		PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
		PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
		PDO::ATTR_EMULATE_PREPARES   => false,
	];
	$pdo = new PDO($dsn, $user, $pass, $opt);

	echo "Connected successfully.";
	echo "<br /><br />";
}
catch (PDOException $e) 
{
    echo 'Error: ' . $e->getMessage();
    exit();
}

echo 'Running query.';
echo "<br />";

// Run Query
$stmt = $pdo->query('SELECT * FROM test');
while ($row = $stmt->fetch())
{
    # echo $row['name'] . "\n";
	var_dump($row);
}

// Close connection
$pdo = null;
```