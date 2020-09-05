void main() {
  List fuel = [
    ['a', 20],
    ['b', 30],
    ['c', 10],
    ['d', 20]
  ];
  List excavation = [
    ['a', 60],
    ['b', 80],
    ['c', 50],
    ['d', 50]
  ];
  int vol = 330;
  int noOfMachines = excavation.length;
  List<dynamic> mostEffecient = [];

  for (int i = 0; i < noOfMachines; i++) {
    List tempList = [excavation[i][0]];
    double temp = excavation[i][1] / fuel[i][1];
    tempList.insert(0, temp);
    mostEffecient.insert(i, tempList);
    //mostEffecient.sort();
  }

  print("Efficency of machines " + mostEffecient.toString());

  printIdeal(vol, excavation, fuel, mostEffecient, noOfMachines);
  //List testList = [1.232, 1.232343, 0.3434, 0.999 ];
  //noClosestToOne(testList);
}

void printValues() {
  print("function working");
}

dynamic printIdeal(vol, excavation, fuel, mostEffecient, noOfMachines) {
  List rankedMachine = [];
  List bestsuit = [];
  dynamic onehrResult = 0;
  dynamic countHrs = 0;
  dynamic totalexcavation = 0;
  List addextraMachine = [];
  dynamic remainingExcavation;
  dynamic mahineindex;
  dynamic machineName;

  for (int i = 0; i < noOfMachines; i++) {
    onehrResult += excavation[i][1];
  }

  if (onehrResult < vol) {
    while (vol > totalexcavation) {
      totalexcavation += onehrResult;
      countHrs += 1;
    }

    if (totalexcavation > vol) {
      remainingExcavation = vol - (totalexcavation - onehrResult);
      countHrs -= 1;

      for (int j = 0; j < noOfMachines; j++) {
        dynamic temp2 = remainingExcavation / excavation[j][1];
        bestsuit.insert(j, temp2);
      }

      // for( int k=0; k<noOfMachines ; k++ ) {
      //   if(bestsuit[k] >1.5 ) {
      //     addextraMachine.insert(k, bestsuit[k]);
      //   }
      // }

// TODO: EXTRA PRINT STATEMENTS FOR DEBUGGING
      // print("extra machines to be added" + addextraMachine.toString());
      // print("bestsuit" + bestsuit.toString());

      machineName = noClosestToOne(bestsuit);
      // print("Extra machine" + machineName.toString());

      // print("remaining Excavation" + remainingExcavation.toString());
      // print("one hour result" + onehrResult.toString());
      // print("total excavation" + totalexcavation.toString());
      // print("total no of hrs required where all machines run  " +
      //     countHrs.toString());
      mahineindex = machineName[1];
      for (int i = 0; i < excavation.length; i++) {
        if (mahineindex != i) {
          print(excavation[i][0] +
              " Machine would need to work " +
              countHrs.toString() +
              " Hrs");
        } else if (mahineindex == i) {
          print(excavation[mahineindex][0].toString() +
              " Machine would need to work " +
              (countHrs + 1).toString() +
              " Hrs");
        }
      }
      // print(excavation[mahineindex][0].toString() +
      //     ", this machine needs to work " +
      //     (countHrs + 1).toString());
    } else {
      print("each machine need to do " + countHrs.toString() + "hrs of work");
    }
  } else {
    print("excessive machines are being");
  }
}

List noClosestToOne(List givenlist) {
  print("closest to one is working");
  double minimum = 0.000000;
  int value_chosen = 1;
  double final_value;
  int index;
  List answer;
  dynamic max_value =
      givenlist.reduce((curr, next) => curr > next ? curr : next); // 8 --> Max

  for (int i = 0; i < givenlist.length; i++) {
    dynamic diff = givenlist[i] - value_chosen;
    if ((diff).abs() < max_value) {
      max_value = (diff).abs();
      final_value = givenlist[i];
      index = i;
    }
    answer = [final_value, index];
  }

  return (answer);
}
