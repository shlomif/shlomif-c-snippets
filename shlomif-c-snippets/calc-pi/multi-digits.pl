
use strict;
use warnings;

my $base = 10000;
#my $base = 10;

sub add_multi_digit
{
    my ($one, $two) = @_;
    my ($min_len, $max_len, @result, $a, $sum, $temp);
    if (scalar(@{$one}) > scalar(@{$two}))
    {
        $max_len = scalar(@{$one});
        $min_len = scalar(@{$two});
    }
    else
    {
        $min_len = scalar(@{$one});
        $max_len = scalar(@{$two});
        $temp = $one;
        $one = $two;
        $two = $temp;
    }

    for($a=0;$a<$max_len+1;$a++)
    {
        $result[$a] = 0;
    }
    for($a=0;$a<$min_len;$a++)
    {
        $sum = $one->[$a] + $two->[$a] + $result[$a];
        $result[$a] = $sum % $base;
        $result[$a+1] = int ($sum / $base);
    }
    for(;$a<$max_len;$a++)
    {
        $sum = $one->[$a] + $result[$a];
        $result[$a] = $sum % $base;
        $result[$a+1] = int ($sum / $base);
    }

    for($a=scalar(@result)-1;$a>=1;$a--)
    {
        last if ($result[$a] != 0)
    }
    @result = @result[0..$a];

    return \@result;
}

sub subtract_multi_digit
{
    my ($one, $two) = @_;
    my ($min_len, $max_len, @result, $a, $diff);
    if (scalar(@{$one}) > scalar(@{$two}))
    {
        $max_len = scalar(@{$one});
        $min_len = scalar(@{$two});
    }
    else
    {
        $min_len = scalar(@{$one});
        $max_len = scalar(@{$two});
    }

    for($a=0;$a<$max_len;$a++)
    {
        $result[$a] = 0;
    }
    for($a=0;$a<$max_len;$a++)
    {
        $diff = $result[$a];
        if (scalar(@{$one}) > $a)
        {
            $diff += $one->[$a];
        }
        if (scalar(@{$two}) > $a)
        {
            $diff -= $two->[$a];
        }
        if ($diff >= 0)
        {
            $result[$a] = $diff;
        }
        else
        {
            $result[$a] = $diff+$base;
            $result[$a+1] = -1;
        }
    }

    for($a=scalar(@result)-1;$a>=1;$a--)
    {
        last if ($result[$a] != 0);
    }
    @result = @result[0..$a];


    return \@result;
}

sub multiply_multi_digit
{
    my ($one, $two) = @_;
    my (@result, $a, $b, $product, $c);
    for($a=0;$a<scalar(@{$one})+scalar(@{$two});$a++)
    {
        $result[$a]=0;
    }
    for($a=0;$a<scalar(@{$one});$a++)
    {
        for($b=0;$b<scalar(@{$two});$b++)
        {
            $product = $one->[$a] * $two->[$b];
            $result[$a+$b] += $product % $base;
            for($c=$a+$b;$result[$c]>=$base;$c++)
            {
                $result[$c+1] += int ($result[$c] / $base);
                $result[$c] %= $base;
            }
            if (int ($product / $base) > 0)
            {
                $result[$a+$b+1] += int ($product / $base);
                for($c=$a+$b+1;$result[$c]>=$base;$c++)
                {
                    $result[$c+1] += int ($result[$c] / $base);
                    $result[$c] %= $base;
                }
            }
        }
    }

    for($a=scalar(@result)-1;$a>=1;$a--)
    {
        last if ($result[$a] != 0);
    }
    @result = @result[0..$a];

    return \@result;
}

sub divide_multi_digit
{
    my ($divide, $div_by) = @_;
    $divide = [ @{$divide} ]; # clone it because we are going to change it
    my (@result, $a, $d_digit, $db_digit, $offset, $multiply_by, @product);

    $result[0] = 0;
    for($a=0;$a < scalar(@{$divide})-scalar(@{$div_by})+1; $a++)
    {
        $result[$a] = 0;
    }

    $d_digit = scalar(@{$divide})-1;
    $db_digit = -1;
    for($a=scalar(@{$div_by})-1;$a>=0;$a--)
    {
        if ($div_by->[$a] > 0)
        {
            $db_digit = $a;
            last;
        }
    }
    if ($db_digit == -1) # div_by equals to 0
    {
        return undef;
    }

    while (1)
    {
        if ($d_digit > $#$divide)
        {
            $d_digit = $#$divide;
        }
        # Check if the division can be ended
        for($a=$d_digit, $d_digit = -1;$a>=0;$a--)
        {
            if ($divide->[$a] > 0)
            {
                $d_digit = $a;
                last;
            }
        }

        if ($db_digit > $d_digit)
        {
            for($a=scalar(@result)-1;$a>=1;$a--)
            {
                last if ($result[$a] != 0);
            }
            @result = @result[0..$a];


            return \@result;
        }


        if ($db_digit == $d_digit)
        {
            for($a=$d_digit;$a>=0;$a--)
            {
                if ($div_by->[$a] > $divide->[$a])
                {
                    for($a=scalar(@result)-1;$a>=1;$a--)
                    {
                        last if ($result[$a] != 0);
                    }
                    @result = @result[0..$a];

                    return \@result;
                }
                elsif ($div_by->[$a] < $divide->[$a])
                {
                    last;
                }
            }
        }


        for ($a=0; $a<=$db_digit; $a++)
        {
            if ($divide->[$d_digit-$a] != $div_by->[$db_digit-$a])
            {
                last;
            }
        }

        if ($a == $db_digit+1)
        {
            $multiply_by = 1;
            $offset = $d_digit - $db_digit;
        }
        elsif ($divide->[$d_digit-$a] > $div_by->[$db_digit-$a])
        {
            $offset = $d_digit - $db_digit;
            if ($a>0)
            {
                $multiply_by = 1;
            }
            else
            {
                my $b = int (($divide->[$d_digit]*$base + (($d_digit>0)?$divide->[$d_digit-1]:0)) /
                             ($div_by->[$db_digit]*$base + (($db_digit>0)?$div_by->[$db_digit-1]:0)));
                $multiply_by = ($b>1)?($b-1):$b;
            }
        }
        else
        {
            $offset = $d_digit - $db_digit - 1;
            if ($a>1)
            {
                $multiply_by = $base-1;
            }
            else
            {
                my $b = int (($divide->[$d_digit]*$base*$base + (($d_digit>0)?$divide->[$d_digit-1]:0)*$base +  (($d_digit>1)?$divide->[$d_digit-1]:0)) /
                             ($div_by->[$db_digit]*$base + (($db_digit>0)?$div_by->[$db_digit-1]:0)));
                $multiply_by = ($b>1)?($b-1):$b;
            }
        }
        @product = @{multiply_multi_digit ($div_by, [ $multiply_by])};
        {
            my (@to_add);
            for($a=0;$a<$offset;$a++)
            {
                push @to_add, 0;
            }
            @product = (@to_add, @product);
        }
        $divide = subtract_multi_digit($divide, \@product);
        $result[$offset] += $multiply_by;
        for($a=$offset;$result[$a]>=$base;$a++)
        {
            $result[$a+1] += int ($result[$a] / $base);
            $result[$a] %= $base;
        }
    }
}


sub print_multi_digit
{
    my $number = shift(@_);
    my $a;
    for($a=0;$a<scalar(@{$number});$a++)
    {
        printf(($a==0)?"%i,":"%04i,", $number->[scalar(@{$number})-$a-1]);
        #print $number->[scalar(@{$number})-$a-1];
    }
    print "\n";
}

sub to_multi_digit
{
    my $number = shift(@_);
    my @result;
    my $a;
    $a=0;
    while ($number > 0)
    {
        $result[$a] = $number % $base;
        $a++;
        $number = int($number / $base);
    }
    return \@result;
}

my $numer = [ 2 ];
my $item = [ 2 ];
my $denom = [ 1 ];

for my $i (1 .. 130)
{
    if ($i % 30 == 0)
    {
        print "$i\n";
    }
    $denom = multiply_multi_digit($denom, to_multi_digit((2*$i+1)));
    $item = multiply_multi_digit($item, to_multi_digit($i));
    $numer = add_multi_digit($item, multiply_multi_digit($numer, to_multi_digit(2*$i+1)));

    #print "denom is ", join('', reverse(@{$denom})), "\n";
    #print "item is ", join('', reverse(@{$item})), "\n";
    #print "numer is ", join('', reverse(@{$numer})), "\n";
}

my $pi = divide_multi_digit([ ((0,) x 40), @{$numer} ], $denom);

open my $out_fh, '>', 'dump.txt';
print "pi is ", join('', reverse(@{$pi})), "\n";
print {$out_fh} "pi is ", join('', reverse(@{$pi})), "\n";
close ($out_fh);

