
use strict;
use warnings;

my $base = 10000;

#my $base = 10;

sub _trim_zeroes
{
    my ($result) = @_;
    while ( @$result > 1 and ( $result->[-1] == 0 ) )
    {
        pop @$result;
    }

    return;
}

sub add_multi_digit
{
    my ( $one, $two ) = @_;
    my ( $ii, );
    if ( scalar( @{$one} ) < scalar( @{$two} ) )
    {
        ( $one, $two ) = ( $two, $one );
    }
    my $max_len = scalar( @{$one} );
    my $min_len = scalar( @{$two} );

    my @result = ( (0) x ( $max_len + 1 ) );
    for ( $ii = 0 ; $ii < $min_len ; ++$ii )
    {
        my $sum = $one->[$ii] + $two->[$ii] + $result[$ii];
        $result[$ii] = $sum % $base;
        $result[ $ii + 1 ] = int( $sum / $base );
    }
    for ( ; $ii < $max_len ; ++$ii )
    {
        my $sum = $one->[$ii] + $result[$ii];
        $result[$ii] = $sum % $base;
        $result[ $ii + 1 ] = int( $sum / $base );
    }
    _trim_zeroes( \@result );
    return \@result;
}

sub subtract_multi_digit
{
    my ( $one, $two ) = @_;
    my ( $min_len, $max_len, );
    if ( scalar( @{$one} ) > scalar( @{$two} ) )
    {
        $max_len = scalar( @{$one} );
        $min_len = scalar( @{$two} );
    }
    else
    {
        $min_len = scalar( @{$one} );
        $max_len = scalar( @{$two} );
    }

    my @result = ( (0) x ($max_len) );
    for my $ii ( 0 .. $max_len - 1 )
    {
        my $diff = $result[$ii];
        if ( scalar( @{$one} ) > $ii )
        {
            $diff += $one->[$ii];
        }
        if ( scalar( @{$two} ) > $ii )
        {
            $diff -= $two->[$ii];
        }
        if ( $diff >= 0 )
        {
            $result[$ii] = $diff;
        }
        else
        {
            $result[$ii] = $diff + $base;
            $result[ $ii + 1 ] = -1;
        }
    }

    _trim_zeroes( \@result );
    return \@result;
}

sub multiply_multi_digit
{
    my ( $one, $two ) = @_;
    my ( @result, $ii, $jj, $product, $c );
    for ( $ii = 0 ; $ii < scalar( @{$one} ) + scalar( @{$two} ) ; ++$ii )
    {
        $result[$ii] = 0;
    }
    for ( $ii = 0 ; $ii < scalar( @{$one} ) ; ++$ii )
    {
        for ( $jj = 0 ; $jj < scalar( @{$two} ) ; $jj++ )
        {
            $product = $one->[$ii] * $two->[$jj];
            $result[ $ii + $jj ] += $product % $base;
            for ( $c = $ii + $jj ; $result[$c] >= $base ; $c++ )
            {
                $result[ $c + 1 ] += int( $result[$c] / $base );
                $result[$c] %= $base;
            }
            if ( int( $product / $base ) > 0 )
            {
                $result[ $ii + $jj + 1 ] += int( $product / $base );
                for ( $c = $ii + $jj + 1 ; $result[$c] >= $base ; $c++ )
                {
                    $result[ $c + 1 ] += int( $result[$c] / $base );
                    $result[$c] %= $base;
                }
            }
        }
    }

    _trim_zeroes( \@result );

    return \@result;
}

sub divide_multi_digit
{
    my ( $divide, $div_by ) = @_;
    $divide = [ @{$divide} ];    # clone it because we are going to change it
    my ( @result, $ii, $d_digit, $db_digit, $offset, $multiply_by, @product );

    $result[0] = 0;
    for (
        $ii = 0 ;
        $ii < scalar( @{$divide} ) - scalar( @{$div_by} ) + 1 ;
        ++$ii
        )
    {
        $result[$ii] = 0;
    }

    $d_digit  = scalar( @{$divide} ) - 1;
    $db_digit = -1;
    for ( $ii = scalar( @{$div_by} ) - 1 ; $ii >= 0 ; --$ii )
    {
        if ( $div_by->[$ii] > 0 )
        {
            $db_digit = $ii;
            last;
        }
    }
    if ( $db_digit == -1 )    # div_by equals to 0
    {
        return undef;
    }

    while (1)
    {
        if ( $d_digit > $#$divide )
        {
            $d_digit = $#$divide;
        }

        # Check if the division can be ended
        for ( $ii = $d_digit, $d_digit = -1 ; $ii >= 0 ; --$ii )
        {
            if ( $divide->[$ii] > 0 )
            {
                $d_digit = $ii;
                last;
            }
        }

        if ( $db_digit > $d_digit )
        {
            _trim_zeroes( \@result );
            return \@result;
        }

        if ( $db_digit == $d_digit )
        {
            for ( $ii = $d_digit ; $ii >= 0 ; --$ii )
            {
                if ( $div_by->[$ii] > $divide->[$ii] )
                {
                    _trim_zeroes( \@result );

                    return \@result;
                }
                elsif ( $div_by->[$ii] < $divide->[$ii] )
                {
                    last;
                }
            }
        }

        for ( $ii = 0 ; $ii <= $db_digit ; ++$ii )
        {
            if ( $divide->[ $d_digit - $ii ] != $div_by->[ $db_digit - $ii ] )
            {
                last;
            }
        }

        if ( $ii == $db_digit + 1 )
        {
            $multiply_by = 1;
            $offset      = $d_digit - $db_digit;
        }
        elsif ( $divide->[ $d_digit - $ii ] > $div_by->[ $db_digit - $ii ] )
        {
            $offset = $d_digit - $db_digit;
            if ( $ii > 0 )
            {
                $multiply_by = 1;
            }
            else
            {
                my $jj = int(
                    (
                        $divide->[$d_digit] * $base + (
                            ( $d_digit > 0 ) ? $divide->[ $d_digit - 1 ] : 0
                        )
                    ) / (
                        $div_by->[$db_digit] * $base + (
                            ( $db_digit > 0 ) ? $div_by->[ $db_digit - 1 ] : 0
                        )
                    )
                );
                $multiply_by = ( $jj > 1 ) ? ( $jj - 1 ) : $jj;
            }
        }
        else
        {
            $offset = $d_digit - $db_digit - 1;
            if ( $ii > 1 )
            {
                $multiply_by = $base - 1;
            }
            else
            {
                my $jj = int(
                    (
                        $divide->[$d_digit] * $base * $base + (
                            ( $d_digit > 0 ) ? $divide->[ $d_digit - 1 ] : 0
                        ) * $base + (
                            ( $d_digit > 1 ) ? $divide->[ $d_digit - 1 ] : 0
                        )
                    ) / (
                        $div_by->[$db_digit] * $base + (
                            ( $db_digit > 0 ) ? $div_by->[ $db_digit - 1 ] : 0
                        )
                    )
                );
                $multiply_by = ( $jj > 1 ) ? ( $jj - 1 ) : $jj;
            }
        }
        @product = @{ multiply_multi_digit( $div_by, [$multiply_by] ) };
        {
            my (@to_add);
            for ( $ii = 0 ; $ii < $offset ; ++$ii )
            {
                push @to_add, 0;
            }
            @product = ( @to_add, @product );
        }
        $divide = subtract_multi_digit( $divide, \@product );
        $result[$offset] += $multiply_by;
        for ( $ii = $offset ; $result[$ii] >= $base ; ++$ii )
        {
            $result[ $ii + 1 ] += int( $result[$ii] / $base );
            $result[$ii] %= $base;
        }
    }
}

sub print_multi_digit
{
    my $number = shift(@_);
    my $ii;
    for ( $ii = 0 ; $ii < scalar( @{$number} ) ; ++$ii )
    {
        printf(
            ( $ii == 0 ) ? "%i," : "%04i,",
            $number->[ scalar( @{$number} ) - $ii - 1 ]
        );

        #print $number->[scalar(@{$number})-$ii-1];
    }
    print "\n";
}

sub to_multi_digit
{
    my $number = shift(@_);
    my @result;
    while ( $number > 0 )
    {
        push @result, $number % $base;
        $number = int( $number / $base );
    }
    return \@result;
}

my $numer = [2];
my $item  = [2];
my $denom = [1];

for my $i ( 1 .. 130 )
{
    if ( $i % 30 == 0 )
    {
        print "$i\n";
    }
    $denom = multiply_multi_digit( $denom, to_multi_digit( ( 2 * $i + 1 ) ) );
    $item  = multiply_multi_digit( $item,  to_multi_digit($i) );
    $numer = add_multi_digit( $item,
        multiply_multi_digit( $numer, to_multi_digit( 2 * $i + 1 ) ) );

    #print "denom is ", join('', reverse(@{$denom})), "\n";
    #print "item is ", join('', reverse(@{$item})), "\n";
    #print "numer is ", join('', reverse(@{$numer})), "\n";
}

my $pi     = divide_multi_digit( [ ( ( 0, ) x 40 ), @{$numer} ], $denom );
my $pi_str = join( '', reverse( @{$pi} ) );
if ( $pi_str !~ m#\A3(?:\.)?1415926535#ms )
{
    die qq#"$pi_str" has wrong digits!#;
}
my $msg = "pi is " . $pi_str . "\n";
open my $out_fh, '>', 'dump.txt';
print $msg;
print {$out_fh} $msg;
close($out_fh);
