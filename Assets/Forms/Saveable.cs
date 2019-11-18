using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace IMMATERIA {
public class Saveable {

  public static string GetFullName( string name ){
    return Application.dataPath + "/DNA/"+name+".dna";
  }

  public static bool Check( string name ){

    if( name == null ){ Debug.Log("NO NAME"); }
    if( String.IsNullOrEmpty(name)){ Debug.Log("NO NAME111"); }
    return File.Exists(GetFullName(name));
  }



  public static void Save( Form form , string name ){

    BinaryFormatter bf = new BinaryFormatter();
    FileStream stream = new FileStream(GetFullName(name),FileMode.Create);

    if( form.intBuffer ){
      int[] data = form.GetIntDNA();
      bf.Serialize(stream,data);
    }else{
      float[] data = form.GetDNA();
      bf.Serialize(stream,data);
    }

    stream.Close();
  }

  public static void Load(Form form , string name){
    if( File.Exists(GetFullName(name))){
      
      BinaryFormatter bf = new BinaryFormatter();
      FileStream stream = new FileStream(GetFullName(name),FileMode.Open);

      if( form.intBuffer ){
        int[] data = bf.Deserialize(stream) as int[];
        form.SetDNA(data);
      }else{
        float[] data = bf.Deserialize(stream) as float[];
        form.SetDNA(data);
      }

      stream.Close();
    }else{
      Debug.Log("Why would you load something that doesn't exist?!??!?");
    }
  }




}
}