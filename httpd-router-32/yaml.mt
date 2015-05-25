RewriteEngine on

% use YAML;
% for my $file ( grep { /\.ya?ml$/ } @ARGV ) {
% my $data = YAML::LoadFile($file);
## FROM <%= $file %>
% for my $rule (@{$data->{rules} || []}) {
RewriteRule <%= $rule->{from} || '.*' %> <%= $rule->{to} || '-' %><%= $rule->{external} ? ' [R=301]' : $rule->{container} ? ' [E=container_host:'.$rule->{container}.']' : '' %>
% }

% }
