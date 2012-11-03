#include <iostream>
#include <string>
#include <sstream>
using namespace std;

#include <stdio.h>
#include <stdlib.h>

// helper functions for int/string conversion
bool stringToInt(const string &s, int &i);
bool stringToDouble(const string &s, double &d);

string intToString(int i);

#ifdef __cplusplus
extern "C" {
#endif

float features[][2] = {{1.0, 2.0}, {3.0, 1.0}, {5.0, 2.0}};

string GetFeatureDistance(string superpixel_id, string superpixel2_id, string feature_id)
{
  int sid1; //superpixel_id as an integer
  int sid2; //superpixel2_id as an integer
  int fid; //feature id as an integer
  double distance;
  stringstream ss; //to write the floating point output into a string
  if(stringToInt(superpixel_id, sid1) && stringToInt(superpixel2_id, sid2) && stringToInt(feature_id, fid)) {
     distance = -(features[sid1][fid] - features[sid2][fid])*(features[sid1][fid] - features[sid2][fid]);
     ss << distance;
     return ss.str();
  }
  else
  {
  	cout << "In function GetFeature: the constant " << superpixel_id << " or "
  		 << feature_id << " does not appear to be an integer." << endl;
  	exit(-1);
  }
}
/*
string GetFeature(string superpixel_id, string feature_id)
{
  int sid; //superpixel_id as an integer
  int fid; //feature id as an integer
  stringstream ss; //to write the floating point output into a string
  if(stringToInt(superpixel_id, sid) && stringToInt(feature_id, fid)) {
     ss << features[sid][fid];
     return ss.str();
  }
  else
  {
  	cout << "In function GetFeature: the constant " << superpixel_id << " or "
  		 << feature_id << " does not appear to be an integer." << endl;
  	exit(-1);
  }
}
*/
/*
string GetDistance(string num1, string num2)
{
   double flnum1;
   double flnum2;
   stringstream ss;
   if(stringToDouble(num1, flnum1) && stringToDouble(num2, flnum2)) {
      ss << ((flnum1 - flnum2)*(flnum1 - flnum2));
      return ss.str();
   }
   else {
  	cout << "In function GetDistance: the constant " << num1 << " or "
  		 << num2 << " does not appear to be an integer." << endl;
  	exit(-1);
  }
}
*/
#ifdef __cplusplus
}
#endif

bool stringToDouble(const string &s, double &d)
{
  istringstream iss(s);
  
  if (iss>>d)
    return true;
  else
    return false;
}

bool stringToInt(const string &s, int &i)
{
  istringstream iss(s);
  
  if (iss>>i)
    return true;
  else
    return false;
}

string intToString(int i)
{
  ostringstream oss;
  oss << i << flush;  
  return(oss.str());
}
