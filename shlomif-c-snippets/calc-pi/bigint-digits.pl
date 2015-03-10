
use strict;
use warnings;

use Math::BigInt;

use IO::All qw/ io /;

my $numer = Math::BigInt->new("2");
my $item = Math::BigInt->new("2");
my $denom = Math::BigInt->new("1");

for my $i (1 .. 130)
{
    if ($i % 30 == 0)
    {
        print "$i\n";
    }
    $denom *= (2*$i+1);
    $item *= $i;
    $numer = $item + ($numer*(2*$i+1));

}

my $pi = ($numer*(Math::BigInt->new("1".("0"x160)))) / $denom;

io->file('dump.txt')->print("pi is $pi.\n");

