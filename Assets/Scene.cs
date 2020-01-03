using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class Scene : Cycle
{
   
   public void OnEnable(){

        Reset();
        _Destroy(); 
        _Create(); 
        _OnGestate();
        _OnGestated();
        _OnBirth(); 
        _OnBirthed();
        _Activate();
   }


   public void OnDisable(){
      _Destroy(); 

        _Deactivate();  
   }
}
}
