
use strict;
use warnings;
use autodie;

use Math::BigInt lib => 'GMP';

my $numer = Math::BigInt->new("1");
my $denom = Math::BigInt->new("1");

for my $i ( 1 .. 130 )
{
    if ( $i % 30 == 0 )
    {
        print "$i\n";
    }
    $denom *= $i;
    $numer = 1 + ( $numer * $i );
}

my $e = ( $numer * ( Math::BigInt->new( "1" . ( "0" x 160 ) ) ) ) / $denom;

print "e is $e.\n";
