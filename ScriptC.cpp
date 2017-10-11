//g++ 

#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <math.h>
#include <vector>
#include <stdlib.h>     /* atof */
#include <stdlib.h>     /* strtod */

using namespace std;

//Global variable
#define HEIGHT 2000		//Number of maximum line in the file
#define WIDTH 200		//Number of maximum column in the file
#define LADDER_NBR 20		//Number of maximum ladder
#define taille_buffer 20

//Function used to extract 1 cellule
string value(string buffer)
{	string var=buffer;
	string tre = var.substr(0,var.find(","));
	std::istringstream stm;	
	stm.str(var);
	return tre;
}

//Main function
int main (void)
{
	// Set up files, input and output
	std::ifstream datafile ("initial_file.csv", ios::in|ios::binary);
	std::fstream results ("arranged_file.csv", ios::out|ios::binary);

	// Set up variables
	char buffer[taille_buffer];		//Buffer where the data which are just read are stored
	double Allele_number2D, Allele_number3D;
	int index_line2D, index_line3D;
	int int_s;
	int index;

	// Set up data matrix
	vector<vector<string> > array2D;
	vector<vector<vector<string> > > array3D;

	cout<<"Setting up the arrays..."<<endl;
	// Set up sizes array2D. (HEIGHT x WIDTH)
	array2D.resize(HEIGHT);
	for (int i = 0; i < HEIGHT; ++i){
		array2D[i].resize(WIDTH);
	}

	// Set up sizes array3D. ( HEIGHT x WIDTH x LADDER_NBR)	//contains the reference Allele (Ladder)
	array3D.resize(HEIGHT);
	for (int i = 0; i < HEIGHT; ++i) {
		array3D[i].resize(WIDTH+1);
		for (int j = 0; j < WIDTH+1; ++j){
			array3D[i][j].resize(LADDER_NBR);
		}
	}

//Read the data
	cout<<"Reading the data..."<<endl;
	std::string line;
	for (int j=0; j< HEIGHT; j++){						//read a given colum
		std::getline(datafile, line);
		std::size_t found = line.find_first_of(",");
		std::size_t beg = 0;
		found = line.find_first_of(",", found + 1);
		for (int i=0; i< WIDTH; i++){					//read a given line
			std::string tre = line.substr(0,line.find(","));
			array2D[j][i] = tre;
			std::string tre2 = line.substr (line.find(",")+1);     // attribute to tre2 line from "," to the end
			line = tre2;
			//if (i>0&&array2D[j][i-1]==tre){array2D[j][i]="";break;}
		}
	}

//Look for the ladder, put them in a array3D (1st dim: ladder type, 2nd dim: column, 3rd dim:line -> the 2nd and 3rd dim are the same as for array2D)
	cout<<"Looking up for the Ladder..."<<endl;
	int compteur_ladder=0;
	for(int j=0;j<HEIGHT;j++) {
		if(array2D[j][1]=="Ladder_NGMSElect"){
			int i=0;
			while (	array2D[j][i]!=""){
				array3D[0][i][compteur_ladder]=array2D[j][i];	//Put the line j (corresponding to the Ladder in the 1st line of array3D
				i++;
			}
			compteur_ladder++;
		}
	}

//Arrange the data, according to the info contain in the Ladder
	cout<<"Arranging the data..."<<endl;
	std::string tester="A";
	for(int j=1;j<HEIGHT;j++) {					//Scan the lines
		for (int compta=0;compta<LADDER_NBR;compta++){		//Scan the columns (data)
			if(array2D[j][1]!="Ladder_NGMSElect"&&array3D[0][4][compta]==array2D[j][4]){	//Look for sample (not ladder) with a given allele array3D[0][4][compta], if the allene of the ladder does not match, compta++, to find the folowing allele
				//Initialisation of the variables of teh columns, for both arrays
				index_line3D=1;
				index_line2D=5;	//column allelle in array2D

			//check if line Y of array3D[Y][][compteur_ladder2] contains data, if yes array3D[0][0][compteur_ladder2]==-1
				while(array3D[index_line3D][WIDTH][compta]==tester){index_line3D++;}
				array3D[index_line3D][WIDTH][compta]=tester;

				index=0;
			//Copy the info of the 1st columns (Sample file, name...)
				for(int i=0;i<5;i++){
					array3D[index_line3D][i][compta]=array2D[j][i];	

				}
			//Copy the info, Allele, size...
				while(array2D[j][index_line2D]!=""){
					if(array2D[j][index_line2D]=="OL") {int_s=1;}
					else if(array2D[j][index_line2D]=="X") {int_s=2;}
					else if(array2D[j][index_line2D]=="Y") {int_s=3;}
					else int_s=4;

					switch (int_s) {
						case 1:
							index_line2D=index_line2D+4;
							break;
						case 2:
							for (int iii=0; iii<4; iii++){		//Copy Allele, Size, Height and Peak Area in array3D
								array3D[index_line3D][5+index+iii][compta]=array2D[j][index_line2D+iii];
							}
							index_line2D=index_line2D+4;
							index=index+4;
							break;
						case 3:
							for (int iii=0; iii<4; iii++){		//Copy Allele, Size, Height and Peak Area in array3D
								array3D[index_line3D][5+index+iii][compta]=array2D[j][index_line2D+iii];
							}
							index_line2D=index_line2D+4;
							index=index+4;
							break;
						case 4:						//In that case, the allele name is a number
							Allele_number2D = atof(array2D[j][index_line2D].c_str()); //c_str is needed to convert string to const char
							Allele_number3D = atof(array3D[0][5+index][compta].c_str());

							while((Allele_number3D<Allele_number2D)&&(array3D[0][5+index][compta]!="")){	//while ladder<sample do
								index=index+4;
								Allele_number3D = atof(array3D[0][5+index][compta].c_str());
							}

							if(((Allele_number3D-Allele_number2D)<0.000001)&&(index+4<WIDTH)){		//if they are the same
								for (int iii=0; iii<4; iii++){		//Copy Allele, Size, Height and Peak Area in array3D
									array3D[index_line3D][5+index+iii][compta]=array2D[j][index_line2D+iii];
								}
							}
							index_line2D=index_line2D+4;
							//index=index+4;
							break;
					}

				}

			}
		}
	}
//Write the data in a text file	
//1st write the header
	for(int i=0;i<WIDTH;i++){
		results<<array2D[0][i]<<",";
	}
	results<<endl;

	for (int k=0;k<LADDER_NBR;k++){
		for(int j=0; j<HEIGHT;j++){
			for(int i=0;i<WIDTH;i++){
				results<<array3D[j][i][k]<<",";
			}
			results<<endl;
			if(array3D[j][0][k]==""){break;}
		}
	}



	return 0;
}


//////////////End main

