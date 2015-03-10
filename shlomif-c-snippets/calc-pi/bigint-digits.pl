
use strict;

use Math::BigInt;

my ($numer, $denom, $item, $pi);
my ($a);

$numer = Math::BigInt->new("2");
$item = Math::BigInt->new("2");
$denom = Math::BigInt->new("1");

for($a=1;$a<=130;$a++)
{
    if ($a % 30 == 0)
    {
        print "$a\n";
    }
    $denom *= (2*$a+1);
    $item *= $a;
    $numer = $item + ($numer*(2*$a+1));
   
}

$pi = ($numer*(Math::BigInt->new("1".("0"x160)))) / $denom;
open O, ">dump.txt";
print "pi is $pi.\n";
close (O);

