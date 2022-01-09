List l = []; //all users//is a list of maps
List companies = [];
List partial = []; //same for this
void setl(List data) {
  l = data;
}

List get data {
  return l;
}

void setpartialdata(List x) {
  partial = x;
}

List partialdata() {
  return partial;
}

List skills = [];
List domains = [];

//TODO::STORE SKILLS AND DOMAIN HERE AND STOP FETCHING AGAIN AND AGAIN
// List messages = [];
void setcompanies(List s) {
  companies = s;
}
