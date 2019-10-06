using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BindDefinedTransform : Binder
{ 
    public string transformName;
    public Transform transformToBind;
    public Matrix4x4 transformMatrix;
    public override void Bind(){
      toBind.BindMatrix( transformName, () => transformToBind.worldToLocalMatrix );
    }


    /*public override void WhileLiving( float v){
//      print(transform.localToWorldMatrix[0]);
      transformMatrix = transform.localToWorldMatrix;
    }*/


  }
