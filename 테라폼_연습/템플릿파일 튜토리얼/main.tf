# Let's try and render the test template using the template_file data source
data "template_file" "test" {
  template = file("test.tmpl")
  vars = {
    "mystring" = local.mystring
    #"mylist"  = local.mylist # This won't work b/c it's not a string 
    #"mylist" = local.mylist # 문자열이 아니기 때문에 작동하지 않습니다.
    "mylist" = join(",", local.mylist)
    # We also cannot pass a map for the same reason
    # First we can get the keys
    "mapkeys" = join(",", keys(local.mymap))
    "mapvalues" = join(",", values(local.mymap))

    # Let's try my set
    "myset" = join(",",local.myset)
  }
}

# Let's create some local values of different object types
locals {
  mystring = "taco"
  mylist = ["chicken","beef","fish"]
  myset = toset(local.mylist)
  mymap = {
      meat = "chicken"
      cheese = "jack"
      shell = "soft"
  }
}
output "template" {
  value = data.template_file.test.rendered
}