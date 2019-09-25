using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PeopleBuffer : Form
{

    public Person[] people;


   /* struct{
      float4x4 head;
      float4x4 anchor;
      float4x4 leftHand;
      float4x4 rightHand;
      float leftTrigger;
      float rightTrigger;
      float volume;
      float debug;
    }*/

    private float[] values;

    public override void Create(){
      values = new float[people.Length*(16*4+4)];
    }

    public override void SetStructSize(){
      structSize = 16 * 4 + 4;
    }

    public override void SetCount(){
      count = people.Length;
    }




    public override void WhileLiving(float v){

      for( int i = 0; i < people.Length; i++ ){

      }

    }



}
