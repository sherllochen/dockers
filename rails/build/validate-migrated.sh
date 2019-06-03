if rails db:migrate:status &> /dev/null; then
  rails db:migrate
else
  rails db:setup
fi