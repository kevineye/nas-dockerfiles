RewriteEngine on

% use YAML;
% for my $file ( grep { /\.ya?ml$/ } @ARGV ) {
% my $data = YAML::LoadFile($file);
## FROM <%= $file %>
% for my $rule (@{$data->{rules} || []}) {
% if ($rule->{scheme}) {
RewriteCond %{REQUEST_SCHEME} <%= $rule->{scheme} %> [NC]
% }
% if ($rule->{host}) {
RewriteCond %{HTTP_HOST} <%= $rule->{host} %> [NC]
% }
RewriteRule <%= $rule->{from} || '.*' %> <%= $rule->{to} || '-' %><%= $rule->{external} ? ' [R=301,L]' : $rule->{container} ? ' [E=container_host:'.$rule->{container}.']' : '' %>
% }

% }
