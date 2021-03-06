use v6;
use Test;

plan 105;

{
    my $r = (1..5).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    is $r.count-only, 5, '$r.count-only works';
    is $r.pull-one, 1, '$r.pull-one == 1 and Range Iterator kept place';
    is $r.pull-one, 2, '$r.pull-one == 2';
    is $r.pull-one, 3, '$r.pull-one == 3';
    is $r.pull-one, 4, '$r.pull-one == 4';
    is $r.pull-one, 5, '$r.pull-one == 5';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is done';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is still done';
}

{
    my $r = (-1.5.Num..^3).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    is $r.count-only, 5, '$r.count-only works';
    is $r.pull-one, -1.5, '$r.pull-one == -1.5 and Range Iterator kept place';
    is $r.pull-one, -.5, '$r.pull-one == -0.5';
    is $r.pull-one, .5, '$r.pull-one == .5';
    is $r.pull-one, 1.5, '$r.pull-one == 1.5';
    is $r.pull-one, 2.5, '$r.pull-one == 2.5';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is done';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is still done';
}

{
    my $r = (-1.5..^3).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    is $r.count-only, 5, '$r.count-only works';
    is $r.pull-one, -1.5, '$r.pull-one == -1.5 and Range Iterator kept place';
    is $r.pull-one, -.5, '$r.pull-one == -0.5';
    is $r.pull-one, .5, '$r.pull-one == .5';
    is $r.pull-one, 1.5, '$r.pull-one == 1.5';
    is $r.pull-one, 2.5, '$r.pull-one == 2.5';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is done';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is still done';
}

{
    my $r = (-1.5.Num^..3).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    is $r.count-only, 4, '$r.count-only works';
    is $r.pull-one, -.5, '$r.pull-one == -0.5 and Range Iterator kept place';
    is $r.pull-one, .5, '$r.pull-one == .5';
    is $r.pull-one, 1.5, '$r.pull-one == 1.5';
    is $r.pull-one, 2.5, '$r.pull-one == 2.5';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is done';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is still done';
}

{
    my $r = (-1..*).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    ok $r.is-lazy, '$r.is-lazy works';
    is $r.pull-one, -1, '$r.pull-one == -1 and Range Iterator kept place';
    is $r.pull-one, 0, '$r.pull-one == 0';
    is $r.pull-one, 1, '$r.pull-one == 1';
    is $r.pull-one, 2, '$r.pull-one == 2';
    is $r.pull-one, 3, '$r.pull-one == 3';
    is $r.pull-one, 4, '$r.pull-one == 4';
    is $r.pull-one, 5, '$r.pull-one == 5';
    loop (my $i = 0; $i < 100; $i++) {
        $r.pull-one;  # 6 through 105
    }
    is $r.pull-one, 106, '$r.pull-one == 106';
}

{
    my $r = (-1.5.Num..*).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    ok $r.is-lazy, '$r.is-lazy works';
    is $r.pull-one, -1.5, '$r.pull-one == -1.5 and Range Iterator kept place';
    is $r.pull-one, -.5, '$r.pull-one == -0.5';
    is $r.pull-one, .5, '$r.pull-one == .5';
    is $r.pull-one, 1.5, '$r.pull-one == 1.5';
    is $r.pull-one, 2.5, '$r.pull-one == 2.5';
    is $r.pull-one, 3.5, '$r.pull-one == 3.5';
    is $r.pull-one, 4.5, '$r.pull-one == 4.5';
}

{
    my $r = (-1.5..*).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    ok $r.is-lazy, '$r.is-lazy works';
    is $r.pull-one, -1.5, '$r.pull-one == -1.5 and Range Iterator kept place';
    is $r.pull-one, -.5, '$r.pull-one == -0.5';
    is $r.pull-one, .5, '$r.pull-one == .5';
    is $r.pull-one, 1.5, '$r.pull-one == 1.5';
    is $r.pull-one, 2.5, '$r.pull-one == 2.5';
    is $r.pull-one, 3.5, '$r.pull-one == 3.5';
    is $r.pull-one, 4.5, '$r.pull-one == 4.5';
}

{
    # Make sure we can read two different Iterators at the same time.
    # (May sound like an odd test, but as I type this, if Range iteration
    #  were implemented with gather/take, this test would fail.)
    my $r1 = (-1..*).iterator;
    my $r2 = (42..*).iterator;
    ok $r1 ~~ Iterator, '$r1 is an Iterator';
    ok $r2 ~~ Iterator, '$r2 is an Iterator';
    is $r1.pull-one, -1, '$r1.pull-one == -1';
    is $r2.pull-one, 42, '$r2.pull-one == 42';
    is $r1.pull-one, 0, '$r1.pull-one == 0';
    is $r2.pull-one, 43, '$r2.pull-one == 43';
    is $r1.pull-one, 1, '$r1.pull-one == 1';
    is $r2.pull-one, 44, '$r2.pull-one == 44';
    is $r1.pull-one, 2, '$r1.pull-one == 2';
    is $r2.pull-one, 45, '$r2.pull-one == 45';
    is $r1.pull-one, 3, '$r1.pull-one == 3';
    is $r2.pull-one, 46, '$r2.pull-one == 46';
    is $r1.pull-one, 4, '$r1.pull-one == 4';
    is $r2.pull-one, 47, '$r2.pull-one == 47';
    is $r1.pull-one, 5, '$r1.pull-one == 5';
    is $r2.pull-one, 48, '$r2.pull-one == 48';
}

{
    my $r = ('d'..'g').iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    is $r.count-only, 4, '$r.count-only works';
    is $r.pull-one, 'd', '$r.pull-one == d and Range Iterator kept place';
    is $r.pull-one, 'e', '$r.pull-one == e';
    is $r.pull-one, 'f', '$r.pull-one == f';
    is $r.pull-one, 'g', '$r.pull-one == g';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is done';
    is $r.pull-one.WHICH, IterationEnd.WHICH, '$r.pull-one is still done';
}

{
    my $r = ('d'..*).iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    ok $r.is-lazy, '$r.is-lazy works';
    is $r.pull-one, 'd', '$r.pull-one == d and Range Iterator kept place';
    is $r.pull-one, 'e', '$r.pull-one == e';
    is $r.pull-one, 'f', '$r.pull-one == f';
    is $r.pull-one, 'g', '$r.pull-one == g';
    is $r.pull-one, 'h', '$r.pull-one == h';
    is $r.pull-one, 'i', '$r.pull-one == i';
}

{
    my $r = (0..'50').iterator;
    ok $r ~~ Iterator, '$r is an Iterator';
    is $r.pull-one, 0, '$r.pull-one == 0';
    is $r.pull-one, 1, '$r.pull-one == 1';
    is $r.pull-one, 2, '$r.pull-one == 2';
    is $r.pull-one, 3, '$r.pull-one == 3';
    is $r.count-only, 47, '$r.count-only works partially through';
    is $r.pull-one, 4, '$r.pull-one == 4 and Range Iterator kept place';
    is $r.pull-one, 5, '$r.pull-one == 5';
    is $r.pull-one, 6, '$r.pull-one == 6';
    is $r.pull-one, 7, '$r.pull-one == 7';
}
