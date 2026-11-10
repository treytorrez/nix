{ ... }: # TODO: this should probably be a module
# TODO: this should serve as options that the user can set which will configure many ai services/closures/apps/whatever. it should provide things like whether offloading should happen. ideally I think it would tell programs like Ollama and llama.cpp when, and how much to offload as well as how to provide/route requests to those local/remote models. it should also help unify managing settings across harnesses like compaction limits, preferred models, and a lot of others. it *could* (in the future) reach to providers/harnesses and enable features enabled here like Zero Data Retention, preferred providers, etc.
{
  modelsLocation = /var/lib/models;
  ramOffloading = true;
  
}
