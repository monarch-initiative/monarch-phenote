WebPhenote, aka PhenoTua is a Monarch adaptation of [Noctua](http://noctua.berkeleybop.org/)

The current instance can be used at http://create.monarchinitiative.org/

We envision PhenoTua as a series of domain-specific widgets and custom forms layered on top of the generic Noctua framework - similar to Plugins for Protege. The exact nature of the architecture and coupling of the projects is evolving.

Currently this repo only contains ultra-minimal files for making a mini test instance of noctua, but with phenotypes. Some of the code was developed in the main noctua repo on https://github.com/geneontology/noctua for convenience.

In the future this repo may go away and be subsumed into a plugins/contrib repo for noctua.

In the interim, the issue tracker should still be useful.

## Technical Details

The interface is best understood in terms of layers: the base system which is a generic graph editing system,
and on top of that are various high-level views, widgets, renderers or forms that abstract away from this lower-level representation.
For example, the *disease-phenotype* form is currently [accessible from the FORM button here](http://create.monarchinitiative.org/).
This presents fields such as "disease" and "phenotype" and "onset" with implicit relationships between them.

The underlying datamodel for PhenoTua is an OWL Abox - i.e. a set of individuals and assertions about those individuals. The individuals can be typed by any class or class expression, typically coming from monarch.owl

An example of a simple OWL assertion would be:

    :000-888-1234 rdf:type NCBITaxon:9606 .
    :000-888-1234 ro:has-phenotype :987-231-090
    :987-231-090 rdf:type HP:0000123

Here we are saying that some human has the phenotype Nephritis. The human is identified only by a URI (the system will generate UUID-like URIs for these).

This gets show in the graph-UI as an edge connecting the two classes:

    [Human] --[has-phenotype]--> [Nephritis]

This should be read as "some human has nephritis"

Evidence can be added on a per-triple basis, refer to the [Minerva OWL specs](https://github.com/geneontology/minerva/blob/master/specs/owl-model.md) for more.

Because we use individuals, the model is infinitely extensible. For example, we can add age of onset:

    :987-231-090 ro:during :555-555-5555
    :555-555-5555 rdf:type HP:0003581

The graph UI is configured to "fold in" or "collapse" some relations such as 'during' to make a more compact display

    [     ]                      [          ]
    [Human] --[has-phenotype]--> [Nephritis ]
    [     ]                      [AdultOnset]

In the "exploded" view each distinct individual is shown as a box:

    [Human] --[has-phenotype]--> [Nephritis ] --[during]--> [AdultOnset]
    
In both cases, only OWL individuals are shown.

The graph UI can be considered the "base metal" layer of the Noctua system, akin to the individual view in Protege. It is possible to say anything possible within the RO and monarch vocabularies here (provided the reasoner does not deem this inconsistent).

For most users this is too low level. WebPhenote will consist of forms and widgets that are "convenience layers" on top of this base system.

For instance the disease-phenotype form here:
http://poole.monarchinitiative.org:8910/basic/gomodel:55bbb58200000001

is intended to emulate a simple phenote configuration. The underlying model is still OWL individuals


    

