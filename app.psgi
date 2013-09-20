use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Amon2::Lite;
use DBI;
use Teng::Schema::Loader;

our $VERSION = '0.10';

sub teng {
  my $dbh = DBI->connect("dbi:SQLite:./users.db", '', '', +{
    Callbacks => {
    },
    sqlite_unicode  => 1,#MySQLは、mysql_enable_utf8 => 1 ,
  });

  my $teng = Teng::Schema::Loader->load(
    dbh       => $dbh,
    namespace => 'MyDB::Schema',
  );

  $teng;
}

my $teng = teng();

# put your configuration here
sub load_config {
    my $c = shift;

    my $mode = $c->mode_name || 'development';

    +{
        'DBI' => [
            'dbi:SQLite:dbname=$mode.db',
            '',
            '',
        ],
    }
}

get '/' => sub {
    my $c = shift;

    my $itr = $teng->search('user');
    $itr->suppress_object_creation(1);

    return $c->render('index.tt',+{ user => [$itr->all]});
};


post '/user/edit' => sub {
    my ($c) = @_;

    my ($id,$column,$value) = @{$c->req->parameters->mixed}{qw/pk name value/};

    $teng->update('user',{ $column => $value},{ id => $id })
        or return $c->create_response(400,[],['bad data']);
   
    return $c->render_json(+{});
};

# load plugins
#__PACKAGE__->load_plugin('Web::CSRFDefender' => {
#    post_only => 1,
#});
# __PACKAGE__->load_plugin('DBI');
# __PACKAGE__->load_plugin('Web::FillInFormLite');
# __PACKAGE__->load_plugin('Web::JSON');

#__PACKAGE__->enable_session();
__PACKAGE__->load_plugin('Web::JSON');
__PACKAGE__->to_app(handle_static => 1);

__DATA__

@@ index.tt
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>XEditable</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
    <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
    <link href="//cdnjs.cloudflare.com/ajax/libs/x-editable/1.4.5/bootstrap-editable/css/bootstrap-editable.css" rel="stylesheet"/>
    <script src="//cdnjs.cloudflare.com/ajax/libs/x-editable/1.4.5/bootstrap-editable/js/bootstrap-editable.min.js"></script>
    <script type="text/javascript" src="[% uri_for('/static/js/main.js') %]"></script>

    <link rel="stylesheet" href="[% uri_for('/static/css/main.css') %]">
</head>
<body>
    <div class="container">
        <header><h1>XEditable</h1></header>
        <section class="row">
            This is a XEditable
        </section>
        <section class="row">

        <table class="table table-bordered table-striped">
            <tr>
                <th width="35%">name</th>
                <th  width="15%">sex</th>
                <th  width="25%">age</th>
                <th  width="25%">birth_date</th>
            </tr>
        [% FOREACH row IN user %]
            <tr>
                <td><a href="#" class="default" data-name="name" data-type="text" data-pk="[% row.id %]" data-title="Enter username">[% row.name %]</a></td>
                <td><a href="#" class="sex" data-name="sex" data-type="select" data-pk="[% row.id %]" data-title="Enter sex">[% row.sex %]</a></td>
                <td><a href="#" class="default" data-name="age" data-type="text" data-pk="[% row.id %]" data-title="Enter age">[% row.age %]</a></td>
                <td><a href="#" class="default" data-name="birth_date" data-type="date" data-pk="[% row.id %]" data-placement="right" data-title="When do you born?">[% row.birth_date %]</a></td>

            </tr>
        [% END %]
        </table>
        </section>
        <footer>Powered by <a href="http://amon.64p.org/">Amon2::Lite</a></footer>
    </div>
</body>
</html>

@@ /static/js/main.js
$.fn.editable.defaults.mode = 'inline';
$(document).ready(function() {
    $('.default').editable({ url: '/user/edit'});
    $('.sex').editable(
        {
            source: [
                {value: 'male', text: 'male'},
                {value: 'female', text: 'female'}
            ],
            url : '/user/edit',
        }
    );
});

@@ /static/css/main.css
footer {
    text-align: right;
}
