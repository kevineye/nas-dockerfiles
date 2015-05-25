use Mojolicious::Lite;

get '/*foo' => sub {
    my ($c) = @_;
    $c->render(text => join ' ', 'got it', @ARGV);
};

app->start(qw(daemon -l http://*:80));
